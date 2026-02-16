import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/// A view modifier that presents toast notifications with queue support.
///
/// This modifier handles:
/// - Queuing multiple toasts and showing them one at a time
/// - Showing and hiding the toast with animation
/// - Auto-dismissing based on duration
/// - Accessibility announcements
/// - Duration extension when VoiceOver is active
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    let style: AnyToastStyle
    let queueMode: ToastQueueMode
    
    @State private var queue: [Toast] = []
    @State private var activeToast: Toast?
    @State private var isPresented = false
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if let activeToast {
                    // Create a toast copy with wrapped actions that auto-dismiss
                    let displayedToast = Toast(
                        title: activeToast.title,
                        message: activeToast.message,
                        role: activeToast.role,
                        icon: activeToast.icon,
                        placement: activeToast.placement,
                        duration: activeToast.duration,
                        haptic: activeToast.haptic,
                        actions: activeToast.actions.map { originalAction in
                            ToastAction(
                                id: originalAction.id,
                                title: originalAction.title,
                                role: originalAction.role
                            ) {
                                originalAction.action()
                                dismissToast()
                            }
                        }
                    )
                    
                    ToastView(toast: displayedToast, isPresented: isPresented)
                        .environment(\.toastStyle, style)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .swipeToDismiss(placement: activeToast.placement) {
                            dismissToast()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(accessibilityLabel(for: activeToast))
                        .accessibilityAddTraits(.isStaticText)
                        .allowsHitTesting(true)
                        .zIndex(999)
                }
            }
            .onChange(of: toast) { newValue in
                handleToastChange(to: newValue)
            }
    }
    
    // MARK: - Queue Management
    
    private func handleToastChange(to newValue: Toast?) {
        guard let newToast = newValue else { return }
        
        // Consume the binding immediately so it's ready for the next toast
        DispatchQueue.main.async {
            toast = nil
        }
        
        enqueue(newToast)
    }
    
    private func enqueue(_ newToast: Toast) {
        switch queueMode {
        case .fifo:
            if activeToast == nil {
                present(newToast)
            } else {
                queue.append(newToast)
            }
            
        case .replaceAll:
            // Cancel any pending dismiss
            workItem?.cancel()
            workItem = nil
            queue.removeAll()
            
            if activeToast != nil {
                // Dismiss current, then show new
                withAnimation {
                    isPresented = false
                }
                let work = DispatchWorkItem { [self] in
                    activeToast = nil
                    present(newToast)
                }
                workItem = work
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: work)
            } else {
                present(newToast)
            }
            
        case .priority:
            if activeToast == nil {
                present(newToast)
            } else {
                queue.append(newToast)
                // Sort by priority (highest first)
                queue.sort { $0.role.queuePriority > $1.role.queuePriority }
            }
        }
    }
    
    // MARK: - Toast Lifecycle
    
    private func present(_ toast: Toast) {
        activeToast = toast
        
        withAnimation {
            isPresented = true
        }
        
        // Trigger haptic feedback
        toast.haptic.trigger(for: toast.role)
        
        // Announce to VoiceOver
        announceToast(toast)
        
        // Schedule auto-dismiss if not indefinite
        if let duration = toast.duration.timeInterval {
            let voiceOverEnabled = isVoiceOverRunning
            let adjustedDuration = voiceOverEnabled ? duration * 1.5 : duration
            scheduleDismiss(after: adjustedDuration)
        }
    }
    
    private func scheduleDismiss(after duration: TimeInterval) {
        workItem?.cancel()
        let work = DispatchWorkItem { [self] in
            dismissToast()
        }
        workItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
    }
    
    private func dismissToast() {
        workItem?.cancel()
        workItem = nil
        
        withAnimation {
            isPresented = false
        }
        
        // Delay clearing the toast to allow animation to complete, then advance
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            activeToast = nil
            advance()
        }
    }
    
    /// Advances to the next toast in the queue.
    private func advance() {
        guard !queue.isEmpty else { return }
        let next = queue.removeFirst()
        
        workItem?.cancel()
        let work = DispatchWorkItem { [self] in
            present(next)
        }
        workItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: work)
    }
    
    // MARK: - Accessibility
    
    private var isVoiceOverRunning: Bool {
        #if canImport(UIKit)
        return UIAccessibility.isVoiceOverRunning
        #elseif canImport(AppKit)
        return NSWorkspace.shared.isVoiceOverEnabled
        #else
        return false
        #endif
    }
    
    private func announceToast(_ toast: Toast) {
        let announcement = accessibilityLabel(for: toast)
        
        #if canImport(UIKit)
        if toast.role == .error {
            UIAccessibility.post(notification: .announcement, argument: announcement)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIAccessibility.post(notification: .announcement, argument: announcement)
            }
        }
        #elseif canImport(AppKit)
        NSAccessibility.post(element: NSApp as Any, notification: .announcementRequested, userInfo: [
            .announcement: announcement,
            .priority: toast.role == .error ? NSAccessibilityPriorityLevel.high : NSAccessibilityPriorityLevel.medium
        ])
        #endif
    }
    
    private func accessibilityLabel(for toast: Toast) -> String {
        let rolePrefix: String
        switch toast.role {
        case .success:
            rolePrefix = "Success"
        case .error:
            rolePrefix = "Error"
        case .warning:
            rolePrefix = "Warning"
        case .info:
            rolePrefix = "Information"
        }
        return "\(rolePrefix): \(toast.message)"
    }
}
