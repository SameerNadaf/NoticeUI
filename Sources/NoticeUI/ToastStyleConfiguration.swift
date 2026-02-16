import SwiftUI

/// Configuration passed to a `ToastStyle` to render the toast.
///
/// This struct provides the data needed to render a toast without
/// exposing implementation details of the toast system.
public struct ToastStyleConfiguration: Sendable {
    /// The message to display.
    public let message: String
    
    /// The title to display.
    public let title: ToastTitle
    
    /// The semantic role of the toast.
    public let role: ToastRole
    
    /// Optional custom SF Symbol name to use instead of the default role icon.
    public let icon: String?
    
    /// Interactive actions available on the toast.
    public let actions: [ToastAction]
    
    /// Creates a new style configuration.
    /// - Parameters:
    ///   - title: The title to display. Defaults to `.automatic`.
    ///   - message: The message to display.
    ///   - role: The semantic role of the toast.
    ///   - icon: Optional custom SF Symbol name.
    ///   - actions: Interactive actions available on the toast.
    public init(title: ToastTitle = .automatic, message: String, role: ToastRole, icon: String? = nil, actions: [ToastAction] = []) {
        self.title = title
        self.message = message
        self.role = role
        self.icon = icon
        self.actions = actions
    }
}
