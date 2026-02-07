import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

/// Internal view that renders a toast using the current style.
///
/// `ToastView` is responsible for:
/// - Rendering the toast using the appropriate style
/// - Handling placement (top, center, bottom)
/// - Respecting safe area insets
/// - Providing animation entry/exit points
struct ToastView: View {
    let toast: Toast
    let isPresented: Bool
    
    @Environment(\.toastStyle) private var style
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        GeometryReader { geometry in
            let safeArea = windowSafeAreaInsets
            VStack {
                switch toast.placement {
                case .top:
                    toastContent
                        .padding(.top, safeArea.top + 16)
                    Spacer()
                case .center:
                    Spacer()
                    toastContent
                    Spacer()
                case .bottom:
                    Spacer()
                    toastContent
                        .padding(.bottom, safeArea.bottom + 16)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .opacity(isPresented ? 1 : 0)
        .offset(y: animationOffset)
        .animation(animation, value: isPresented)
    }
    
    /// Gets safe area insets from the window (works even when ignoresSafeArea is used)
    private var windowSafeAreaInsets: EdgeInsets {
        #if canImport(UIKit)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return EdgeInsets()
        }
        let insets = window.safeAreaInsets
        return EdgeInsets(top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right)
        #elseif canImport(AppKit)
        guard let window = NSApplication.shared.keyWindow ?? NSApplication.shared.windows.first,
              let contentView = window.contentView else {
            return EdgeInsets()
        }
        let insets = contentView.safeAreaInsets
        return EdgeInsets(top: insets.top, leading: insets.left, bottom: insets.bottom, trailing: insets.right)
        #else
        return EdgeInsets()
        #endif
    }
    
    private var toastContent: some View {
        style.makeBody(
            configuration: ToastStyleConfiguration(
                message: toast.message,
                role: toast.role,
                icon: toast.icon,
                actions: toast.actions
            )
        )
        .frame(maxWidth: 500)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
    }
    
    // MARK: - Animation
    
    private var animationOffset: CGFloat {
        guard !reduceMotion else { return 0 }
        guard !isPresented else { return 0 }
        
        switch toast.placement {
        case .top:
            return -50
        case .center:
            return 0
        case .bottom:
            return 50
        }
    }
    
    private var animation: Animation {
        if reduceMotion {
            return .easeInOut(duration: 0.2)
        } else {
            return .spring(response: 0.35, dampingFraction: 0.8)
        }
    }
}

// MARK: - Preview Support

#if DEBUG
#Preview("Toast Placements") {
    VStack(spacing: 20) {
        Text("Toast Preview")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay {
        ToastView(
            toast: Toast(message: "Success message", role: .success, placement: .top),
            isPresented: true
        )
    }
}

#Preview("Pale Style") {
    VStack(spacing: 20) {
        Text("Pale Style Preview")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay {
        ToastView(
            toast: Toast(message: "You have successfully completed the trip", role: .success, placement: .center),
            isPresented: true
        )
    }
    .toastStyle(PaleToastStyle())
}

#Preview("Vibrant Style") {
    VStack(spacing: 20) {
        Text("Vibrant Style Preview")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .overlay {
        ToastView(
            toast: Toast(message: "You have failed to complete the trip", role: .error, placement: .center),
            isPresented: true
        )
    }
    .toastStyle(VibrantToastStyle())
}
#endif

