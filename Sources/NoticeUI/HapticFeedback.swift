import Foundation

#if canImport(UIKit)
import UIKit
#endif

/// Type of haptic feedback to play when a toast appears.
///
/// Haptic feedback is only available on iOS. On macOS, these options are ignored.
///
/// ## Usage
/// ```swift
/// Toast(
///     message: "Operation completed!",
///     role: .success,
///     haptic: .success
/// )
/// ```
public enum ToastHapticFeedback: Sendable, Equatable {
    /// No haptic feedback.
    case none
    /// Light impact feedback.
    case light
    /// Medium impact feedback.
    case medium
    /// Heavy impact feedback.
    case heavy
    /// Success notification feedback.
    case success
    /// Warning notification feedback.
    case warning
    /// Error notification feedback.
    case error
    /// Automatic feedback based on the toast's role.
    case automatic
    
    /// Triggers the haptic feedback (iOS only).
    @MainActor
    public func trigger(for role: ToastRole? = nil) {
        #if canImport(UIKit) && !os(watchOS)
        switch self {
        case .none:
            return
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .automatic:
            guard let role else { return }
            switch role {
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .info:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        }
        #endif
    }
}
