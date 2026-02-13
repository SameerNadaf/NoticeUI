/// Semantic role of a toast notification.
///
/// The role affects both visual styling and accessibility behavior.
/// For example, `.error` toasts are announced immediately by VoiceOver,
/// while other roles use polite announcements.
public enum ToastRole: Sendable, Equatable {
    /// Indicates a successful operation.
    case success
    /// Indicates an error or failure.
    case error
    /// Indicates a warning that requires attention.
    case warning
    /// Indicates general information.
    case info
    
    /// Internal priority value for queue sorting.
    /// Higher values indicate higher severity.
    var queuePriority: Int {
        switch self {
        case .error:   return 3
        case .warning: return 2
        case .success: return 1
        case .info:    return 0
        }
    }
}
