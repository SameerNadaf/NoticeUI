import SwiftUI

/// A title for a toast notification.
///
/// ## Titles
/// Toasts can have a custom title, use the default role title, or hide the title:
/// ```swift
/// Toast(title: "Saved", message: "Your changes have been saved") // Custom title (localized)
/// Toast(title: nil, message: "No title shown") // No title
/// Toast(message: "Uses default role title") // Default title
/// ```
public enum ToastTitle: ExpressibleByStringLiteral, ExpressibleByNilLiteral, Equatable {
    /// Uses the default title associated with the toast's role (e.g., "Success", "Error").
    case automatic
    
    /// Uses a custom localized string as the title.
    case custom(LocalizedStringKey, String)
    
    /// Hides the title completely.
    case none
    
    /// The localized string key for rendering, if available.
    public var localizedStringKey: LocalizedStringKey? {
        switch self {
        case .custom(let key, _): return key
        case .automatic, .none: return nil
        }
    }
    
    /// The plain string value, if available.
    public var stringValue: String? {
        switch self {
        case .custom(_, let string): return string
        case .automatic, .none: return nil
        }
    }
    
    public init(stringLiteral value: String) {
        self = .custom(LocalizedStringKey(value), value)
    }
    
    public init(nilLiteral: ()) {
        self = .none
    }
    
    public static func == (lhs: ToastTitle, rhs: ToastTitle) -> Bool {
        switch (lhs, rhs) {
        case (.automatic, .automatic):
            return true
        case (.none, .none):
            return true
        case (.custom(_, let lhsString), .custom(_, let rhsString)):
            return lhsString == rhsString
        default:
            return false
        }
    }
}
