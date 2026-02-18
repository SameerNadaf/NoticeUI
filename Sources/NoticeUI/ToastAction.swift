import SwiftUI

/// An action that can be performed from a toast.
public struct ToastAction: Identifiable, @unchecked Sendable {
    /// Unique identifier for this action.
    public let id: UUID
    
    /// The localized title of the button.
    public let title: LocalizedStringKey
    
    /// The plain string title for accessibility and non-localized use.
    public let titleString: String
    
    /// The semantic role of the button (e.g., destructive, cancel).
    public let role: ButtonRole?
    
    /// The action to perform when the button is tapped.
    public let action: @Sendable () -> Void
    
    /// Creates a new toast action with a localized title.
    /// - Parameters:
    ///   - id: Unique identifier. Defaults to a new UUID.
    ///   - title: The localized button title.
    ///   - role: The button role. Defaults to `nil`.
    ///   - action: The closure to execute when tapped.
    public init(
        id: UUID = UUID(),
        title: LocalizedStringKey,
        role: ButtonRole? = nil,
        action: @escaping @Sendable () -> Void
    ) {
        self.id = id
        self.title = title
        self.titleString = "\(title)"
        self.role = role
        self.action = action
    }
    
    /// Creates a new toast action with a plain string title.
    /// - Parameters:
    ///   - id: Unique identifier. Defaults to a new UUID.
    ///   - title: The button title as a plain string (not localized).
    ///   - role: The button role. Defaults to `nil`.
    ///   - action: The closure to execute when tapped.
    public init(
        id: UUID = UUID(),
        title: String,
        role: ButtonRole? = nil,
        action: @escaping @Sendable () -> Void
    ) {
        self.id = id
        self.title = LocalizedStringKey(title)
        self.titleString = title
        self.role = role
        self.action = action
    }
    
    public static func == (lhs: ToastAction, rhs: ToastAction) -> Bool {
        lhs.id == rhs.id
    }
}
 
extension ToastAction: Equatable {}
