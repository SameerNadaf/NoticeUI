import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/// A view modifier that presents a toast notification.
///
/// This modifier handles:
/// - Showing and hiding the toast with animation
/// - Auto-dismissing based on duration
/// - Accessibility announcements
/// - Duration extension when VoiceOver is active
struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    let style: AnyToastStyle
    
    @State private var workItem: DispatchWorkItem?
    @State private var isPresented = false
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                if let toast {
                    ToastView(toast: toast, isPresented: isPresented)
                        .environment(\.toastStyle, style)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .swipeToDismiss(placement: toast.placement) {
                            dismissToast()
                        }
                        .onTapGesture {
                            dismissToast()
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(accessibilityLabel(for: toast))
                        .accessibilityAddTraits(.isStaticText)
                        .allowsHitTesting(true)
                        .zIndex(999)
                }
            }
            .onChange(of: toast) { newValue in
                handleToastChange(to: newValue)
            }
    }
    
    // MARK: - Toast Lifecycle
    
    private func handleToastChange(to newValue: Toast?) {
        // Cancel any pending dismiss
        workItem?.cancel()
        workItem = nil
        
        if let toast = newValue {
            // Show toast
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

        } else {
            // Hide toast
            withAnimation {
                isPresented = false
            }
        }
    }
    
    private func scheduleDismiss(after duration: TimeInterval) {
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
        
        // Delay clearing the toast to allow animation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            toast = nil
        }
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
        // Post accessibility announcement
        // Errors are announced immediately, others use standard posting
        if toast.role == .error {
            UIAccessibility.post(notification: .announcement, argument: announcement)
        } else {
            // Slight delay for non-critical announcements
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIAccessibility.post(notification: .announcement, argument: announcement)
            }
        }
        #elseif canImport(AppKit)
        // macOS doesn't have the same announcement API, use NSAccessibility
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
