import SwiftUI

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
            style.makeBody(
                configuration: ToastStyleConfiguration(
                    message: toast.message,
                    role: toast.role
                )
            )
            .frame(maxWidth: min(geometry.size.width - 32, 400))
            .position(position(in: geometry))
            .opacity(isPresented ? 1 : 0)
            .offset(y: animationOffset)
            .animation(animation, value: isPresented)
        }
    }
    
    // MARK: - Layout
    
    private func position(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let safeArea = geometry.safeAreaInsets
        
        switch toast.placement {
        case .top:
            return CGPoint(x: x, y: safeArea.top + 60)
        case .center:
            return CGPoint(x: x, y: geometry.size.height / 2)
        case .bottom:
            return CGPoint(x: x, y: geometry.size.height - safeArea.bottom - 60)
        }
    }
    
    // MARK: - Animation
    
    private var animationOffset: CGFloat {
        guard !reduceMotion else { return 0 }
        guard !isPresented else { return 0 }
        
        switch toast.placement {
        case .top:
            return -20
        case .center:
            return 0
        case .bottom:
            return 20
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
