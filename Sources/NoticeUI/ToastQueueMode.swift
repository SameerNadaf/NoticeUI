/// Defines how the toast queue handles incoming toasts.
///
/// The queue mode determines whether new toasts wait their turn,
/// replace existing ones, or are reordered by severity.
///
/// ## Usage
/// ```swift
/// .toast($toast, queueMode: .fifo)
/// .toast($toast, queueMode: .priority)
/// ```
public enum ToastQueueMode: Sendable {
    /// Standard first-in, first-out queue.
    ///
    /// New toasts are appended to the end of the queue and shown
    /// after all previously queued toasts have been dismissed.
    /// This is the default behavior.
    case fifo
    
    /// New toast immediately replaces the current toast and clears the queue.
    ///
    /// Use this when only the most recent notification matters,
    /// such as live status updates or real-time feed messages.
    case replaceAll
    
    /// Toasts are ordered by role severity.
    ///
    /// Higher-severity roles are shown before lower-severity ones:
    /// `error` > `warning` > `success` > `info`.
    ///
    /// This ensures critical messages (like errors) are seen first,
    /// even if they were enqueued after less important notifications.
    case priority
}
