/// Where a toast appears on screen.
///
/// Placement respects safe area insets automatically.
public enum ToastPlacement: Sendable, Equatable {
    /// Toast appears at the top of the screen.
    case top
    /// Toast appears in the center of the screen.
    case center
    /// Toast appears at the bottom of the screen.
    case bottom
}
