import Foundation

/// How long a toast remains visible before auto-dismissing.
///
/// When VoiceOver is active, durations are automatically extended
/// to ensure the announcement completes.
public enum ToastDuration: Sendable, Equatable {
    /// Short duration (2 seconds).
    case short
    /// Long duration (4 seconds).
    case long
    /// Custom duration in seconds.
    case custom(TimeInterval)
    /// Toast remains visible until manually dismissed.
    case indefinite
    
    /// The time interval for this duration, or `nil` for indefinite.
    public var timeInterval: TimeInterval? {
        switch self {
        case .short:
            return 2.0
        case .long:
            return 4.0
        case .custom(let seconds):
            return seconds
        case .indefinite:
            return nil
        }
    }
}
