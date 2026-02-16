import Foundation

/// A title for a toast notification.
///
/// ## Titles
/// Toasts can have a custom title, use the default role title, or hide the title:
/// ```swift
/// Toast(title: "Saved", message: "Your changes have been saved") // Custom title
/// Toast(title: nil, message: "No title shown") // No title
/// Toast(message: "Uses default role title") // Default title
/// ```
public enum ToastTitle: ExpressibleByStringLiteral, ExpressibleByNilLiteral, Equatable, Sendable {
    /// Uses the default title associated with the toast's role (e.g., "Success", "Error").
    case automatic
    
    /// Uses a custom string as the title.
    case custom(String)
    
    /// Hides the title completely.
    case none
    
    public init(stringLiteral value: String) {
        self = .custom(value)
    }
    
    public init(nilLiteral: ()) {
        self = .none
    }
}
