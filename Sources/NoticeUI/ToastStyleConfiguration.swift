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
    
    /// Creates a new style configuration.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - role: The semantic role of the toast.
    public init(message: String, role: ToastRole) {
        self.message = message
        self.role = role
    }
}
