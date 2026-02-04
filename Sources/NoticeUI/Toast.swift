import Foundation

/// A toast notification to be displayed.
///
/// `Toast` represents the intent and data for a notification.
/// It does not contain any styling information — styles are applied
/// separately via `ToastStyle`.
///
/// ## Usage
/// ```swift
/// @State private var toast: Toast?
///
/// Button("Show Success") {
///     toast = Toast(message: "Operation completed!", role: .success)
/// }
/// .toast($toast)
/// ```
public struct Toast: Identifiable, Sendable, Equatable {
    /// Unique identifier for this toast.
    public let id: UUID
    
    /// The message to display.
    public let message: String
    
    /// The semantic role of this toast.
    public let role: ToastRole
    
    /// Optional custom SF Symbol name to use instead of the default role icon.
    public let icon: String?
    
    /// Where the toast appears on screen.
    public let placement: ToastPlacement
    
    /// How long the toast remains visible.
    public let duration: ToastDuration
    
    /// Creates a new toast notification.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - role: The semantic role. Defaults to `.info`.
    ///   - icon: Optional custom SF Symbol name. Defaults to `nil` (uses role icon).
    ///   - placement: Where to show the toast. Defaults to `.top`.
    ///   - duration: How long to show the toast. Defaults to `.short`.
    public init(
        message: String,
        role: ToastRole = .info,
        icon: String? = nil,
        placement: ToastPlacement = .top,
        duration: ToastDuration = .short
    ) {
        self.id = UUID()
        self.message = message
        self.role = role
        self.icon = icon
        self.placement = placement
        self.duration = duration
    }
}
