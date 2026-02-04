import SwiftUI

/// Configuration passed to a `ToastStyle` to render the toast.
///
/// This struct provides the data needed to render a toast without
/// exposing implementation details of the toast system.
public struct ToastStyleConfiguration: Sendable {
    /// The message to display.
    public let message: String
    
    /// The semantic role of the toast.
    public let role: ToastRole
    
    /// Optional custom SF Symbol name to use instead of the default role icon.
    public let icon: String?
    
    /// Creates a new style configuration.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - role: The semantic role of the toast.
    ///   - icon: Optional custom SF Symbol name.
    public init(message: String, role: ToastRole, icon: String? = nil) {
        self.message = message
        self.role = role
        self.icon = icon
    }
}
