import SwiftUI

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
/// // Localized message (looks up key in Localizable.strings)
/// Button("Show Success") {
///     toast = Toast(message: "operation_completed", role: .success)
/// }
///
/// // Plain string message (no localization lookup)
/// let msg = "Dynamic message"
/// Button("Show Info") {
///     toast = Toast(message: msg, role: .info)
/// }
/// .toast($toast)
/// ```
public struct Toast: Identifiable, @unchecked Sendable, Equatable {
    /// Unique identifier for this toast.
    public let id: UUID
    
    /// The title to display. Defaults to `.automatic`.
    public let title: ToastTitle
    
    /// The localized message to display.
    public let message: LocalizedStringKey
    
    /// The plain string message for accessibility and non-localized use.
    public let messageString: String
    
    /// The semantic role of this toast.
    public let role: ToastRole
    
    /// Optional custom SF Symbol name to use instead of the default role icon.
    public let icon: String?
    
    /// Where the toast appears on screen.
    public let placement: ToastPlacement
    
    /// How long the toast remains visible.
    public let duration: ToastDuration
    
    /// Haptic feedback to trigger when toast appears.
    public let haptic: ToastHapticFeedback
    
    /// Interactive actions available on the toast.
    public let actions: [ToastAction]
    
    /// Creates a new toast notification with a localized message.
    /// - Parameters:
    ///   - title: The title to display. Defaults to `.automatic` (uses role name).
    ///            Pass `nil` to hide the title.
    ///   - message: The localized message to display.
    ///   - role: The semantic role. Defaults to `.info`.
    ///   - icon: Optional custom SF Symbol name. Defaults to `nil` (uses role icon).
    ///   - placement: Where to show the toast. Defaults to `.top`.
    ///   - duration: How long to show the toast. Defaults to `.short`.
    ///   - haptic: Haptic feedback to trigger. Defaults to `.automatic`.
    ///   - actions: Interactive actions available on the toast. Defaults to `[]`.
    public init(
        title: ToastTitle = .automatic,
        message: LocalizedStringKey,
        role: ToastRole = .info,
        icon: String? = nil,
        placement: ToastPlacement = .top,
        duration: ToastDuration = .short,
        haptic: ToastHapticFeedback = .automatic,
        actions: [ToastAction] = []
    ) {
        self.id = UUID()
        self.title = title
        self.message = message
        self.messageString = "\(message)"
        self.role = role
        self.icon = icon
        self.placement = placement
        self.duration = duration
        self.haptic = haptic
        self.actions = actions
    }
    
    /// Creates a new toast notification with a plain string message.
    /// - Parameters:
    ///   - title: The title to display. Defaults to `.automatic` (uses role name).
    ///            Pass `nil` to hide the title.
    ///   - message: The message to display as a plain string (not localized).
    ///   - role: The semantic role. Defaults to `.info`.
    ///   - icon: Optional custom SF Symbol name. Defaults to `nil` (uses role icon).
    ///   - placement: Where to show the toast. Defaults to `.top`.
    ///   - duration: How long to show the toast. Defaults to `.short`.
    ///   - haptic: Haptic feedback to trigger. Defaults to `.automatic`.
    ///   - actions: Interactive actions available on the toast. Defaults to `[]`.
    public init(
        title: ToastTitle = .automatic,
        message: String,
        role: ToastRole = .info,
        icon: String? = nil,
        placement: ToastPlacement = .top,
        duration: ToastDuration = .short,
        haptic: ToastHapticFeedback = .automatic,
        actions: [ToastAction] = []
    ) {
        self.id = UUID()
        self.title = title
        self.message = LocalizedStringKey(message)
        self.messageString = message
        self.role = role
        self.icon = icon
        self.placement = placement
        self.duration = duration
        self.haptic = haptic
        self.actions = actions
    }
    
    public static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id
    }
}
