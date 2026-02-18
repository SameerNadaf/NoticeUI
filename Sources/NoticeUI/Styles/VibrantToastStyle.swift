import SwiftUI

/// A high-contrast, vibrant toast style.
///
/// This style features a solid role-colored background with white text
/// and icon. Intended for important notifications like warnings and errors
/// that need to grab the user's attention.
///
/// ## Visual Design
/// - Solid role-colored background
/// - White icon in a translucent circle
/// - White text for maximum contrast
public struct VibrantToastStyle: ToastStyle, Sendable {
    
    /// Creates a new vibrant toast style.
    public init() {}
    
    public func makeBody(configuration: ToastStyleConfiguration) -> some View {
        HStack(spacing: 12) {
            // Icon circle
            Circle()
                .fill(.white.opacity(0.25))
                .frame(width: 40, height: 40)
                .overlay(
                    icon(for: configuration)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                )
            
            // Content and Actions
            VStack(alignment: .leading, spacing: 8) {
                // Text content
                VStack(alignment: .leading, spacing: 2) {
                    if let titleText = title(for: configuration) {
                        Text(titleText)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    
                    Text(configuration.message)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.85))
                        .lineLimit(2)
                }
                
                // Actions
                if !configuration.actions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(configuration.actions) { action in
                            Button(action: action.action) {
                                Text(action.title)
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(roleColor(for: configuration.role)) // Use role color for text
                            .background(
                                Capsule()
                                    .fill(.white) // White background for contrast
                            )
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            VibrantBackgroundView(role: configuration.role)
        )
    }
}

// MARK: - Private Helpers

private func icon(for configuration: ToastStyleConfiguration) -> Image {
    if let customIcon = configuration.icon {
        return Image(systemName: customIcon)
    }
    return roleIcon(for: configuration.role)
}

private func title(for configuration: ToastStyleConfiguration) -> LocalizedStringKey? {
    switch configuration.title {
    case .automatic:
        return roleTitle(for: configuration.role)
    case .custom(let key, _):
        return key
    case .none:
        return nil
    }
}

private func roleIcon(for role: ToastRole) -> Image {
    switch role {
    case .success:
        return Image(systemName: "checkmark")
    case .error:
        return Image(systemName: "info")
    case .warning:
        return Image(systemName: "exclamationmark")
    case .info:
        return Image(systemName: "info")
    }
}

private func roleTitle(for role: ToastRole) -> LocalizedStringKey {
    switch role {
    case .success:
        return "Success"
    case .error:
        return "Error"
    case .warning:
        return "Warning"
    case .info:
        return "Info"
    }
}

private func roleColor(for role: ToastRole) -> Color {
    switch role {
    case .success:
        return Color(red: 0.35, green: 0.78, blue: 0.62)  // Bright Mint
    case .error:
        return Color(red: 0.91, green: 0.45, blue: 0.47)  // Bright Red
    case .warning:
        return Color(red: 0.95, green: 0.77, blue: 0.35)  // Bright Gold
    case .info:
        return Color(red: 0.40, green: 0.65, blue: 0.88)  // Bright Blue
    }
}

// MARK: - Private Views

private struct VibrantBackgroundView: View {
    let role: ToastRole
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(backgroundColor)
    }
    
    private var backgroundColor: Color {
        if colorScheme == .dark {
            switch role {
            case .success:
                return Color(red: 0.20, green: 0.55, blue: 0.40) // Deeper Mint
            case .error:
                return Color(red: 0.75, green: 0.30, blue: 0.32) // Deeper Red
            case .warning:
                return Color(red: 0.80, green: 0.60, blue: 0.20) // Deeper Gold
            case .info:
                return Color(red: 0.25, green: 0.45, blue: 0.70) // Deeper Blue
            }
        } else {
            switch role {
            case .success:
                return Color(red: 0.35, green: 0.78, blue: 0.62)  // Bright Mint
            case .error:
                return Color(red: 0.91, green: 0.45, blue: 0.47)  // Bright Red
            case .warning:
                return Color(red: 0.95, green: 0.77, blue: 0.35)  // Bright Gold
            case .info:
                return Color(red: 0.40, green: 0.65, blue: 0.88)  // Bright Blue
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Vibrant - All Roles") {
    VStack(spacing: 16) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            VibrantToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "This is a \(String(describing: role)) message",
                    role: role
                )
            )
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
}

#Preview("Vibrant - Dark Mode") {
    VStack(spacing: 16) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            VibrantToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "This is a \(String(describing: role)) message",
                    role: role
                )
            )
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.1))
    .preferredColorScheme(.dark)
}
#endif
