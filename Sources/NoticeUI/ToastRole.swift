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
}
