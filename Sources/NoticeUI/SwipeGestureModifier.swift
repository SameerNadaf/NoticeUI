import SwiftUI

/// A view modifier that adds swipe-to-dismiss gesture to toast views.
///
/// The swipe direction is determined by the toast placement:
/// - Top: Swipe up to dismiss
/// - Bottom: Swipe down to dismiss
/// - Center: Swipe left or right to dismiss
struct SwipeToDismissModifier: ViewModifier {
    let placement: ToastPlacement
    let onDismiss: () -> Void
    
    @State private var offset: CGSize = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    /// Threshold distance to trigger dismissal
    private let dismissThreshold: CGFloat = 50
    
    func body(content: Content) -> some View {
        content
            .offset(dragOffset)
            .opacity(dragOpacity)
            .gesture(dragGesture)
            .animation(reduceMotion ? .none : .interactiveSpring(), value: offset)
    }
    
    // MARK: - Gesture
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                offset = constrainedOffset(for: value.translation)
            }
            .onEnded { value in
                let translation = value.translation
                if shouldDismiss(for: translation) {
                    // Complete the dismiss animation
                    offset = finalOffset(for: translation)
                    onDismiss()
                } else {
                    // Snap back
                    offset = .zero
                }
            }
    }
    
    // MARK: - Offset Calculations
    
    private var dragOffset: CGSize {
        offset
    }
    
    private var dragOpacity: Double {
        let progress = dismissProgress
        return max(0, 1 - progress * 0.5)
    }
    
    private var dismissProgress: Double {
        switch placement {
        case .top:
            return max(0, -offset.height / dismissThreshold)
        case .bottom:
            return max(0, offset.height / dismissThreshold)
        case .center:
            return abs(offset.width) / dismissThreshold
        }
    }
    
    /// Constrains the offset based on the allowed drag direction.
    private func constrainedOffset(for translation: CGSize) -> CGSize {
        switch placement {
        case .top:
            // Only allow upward drag
            return CGSize(width: 0, height: min(0, translation.height))
        case .bottom:
            // Only allow downward drag
            return CGSize(width: 0, height: max(0, translation.height))
        case .center:
            // Allow horizontal drag
            return CGSize(width: translation.width, height: 0)
        }
    }
    
    /// Determines if the drag translation should trigger a dismiss.
    private func shouldDismiss(for translation: CGSize) -> Bool {
        switch placement {
        case .top:
            return -translation.height > dismissThreshold
        case .bottom:
            return translation.height > dismissThreshold
        case .center:
            return abs(translation.width) > dismissThreshold
        }
    }
    
    /// Returns the final offset for the dismiss animation.
    private func finalOffset(for translation: CGSize) -> CGSize {
        switch placement {
        case .top:
            return CGSize(width: 0, height: -200)
        case .bottom:
            return CGSize(width: 0, height: 200)
        case .center:
            return CGSize(width: translation.width > 0 ? 200 : -200, height: 0)
        }
    }
}

// MARK: - View Extension

extension View {
    /// Adds swipe-to-dismiss gesture to a toast view.
    /// - Parameters:
    ///   - placement: The toast placement (determines swipe direction).
    ///   - onDismiss: Action to perform when dismissed via swipe.
    func swipeToDismiss(placement: ToastPlacement, onDismiss: @escaping () -> Void) -> some View {
        modifier(SwipeToDismissModifier(placement: placement, onDismiss: onDismiss))
    }
}
