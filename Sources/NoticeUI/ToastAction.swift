import SwiftUI

/// An action that can be performed from a toast.
public struct ToastAction: Identifiable, Sendable {
    /// Unique identifier for this action.
    public let id: UUID
    
    /// The title of the button.
    public let title: String
    
    /// The semantic role of the button (e.g., destructive, cancel).
    public let role: ButtonRole?
    
    /// The action to perform when the button is tapped.
    public let action: @Sendable () -> Void
    
    /// Creates a new toast action.
    /// - Parameters:
    ///   - title: The button title.
    ///   - role: The button role. Defaults to `nil`.
    ///   - action: The closure to execute when tapped.
    public init(
        id: UUID = UUID(),
        title: String,
        role: ButtonRole? = nil,
        action: @escaping @Sendable () -> Void
    ) {
        self.id = id
        self.title = title
        self.role = role
        self.action = action
    }
    
    public static func == (lhs: ToastAction, rhs: ToastAction) -> Bool {
        lhs.id == rhs.id
    }
}
 
extension ToastAction: Equatable {}
