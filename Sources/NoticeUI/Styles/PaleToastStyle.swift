import SwiftUI

/// A subtle, low-contrast toast style.
///
/// This style features a light role-tinted background with a colored
/// left border accent. Suitable for low-priority feedback that shouldn't
/// demand immediate attention.
///
/// ## Visual Design
/// - Light background tinted with the role color
/// - Prominent left border in the role color
/// - Role icon in a colored circle
/// - Dark text for readability
public struct PaleToastStyle: ToastStyle, Sendable {
    
    /// Creates a new pale toast style.
    public init() {}
    
    public func makeBody(configuration: ToastStyleConfiguration) -> some View {
        HStack(spacing: 12) {
            // Icon circle
            Circle()
                .fill(roleColor(for: configuration.role))
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
                            .foregroundStyle(.primary)
                    }
                    
                    Text(configuration.message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
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
                            .foregroundStyle(roleColor(for: configuration.role))
                            .background(
                                Capsule()
                                    .strokeBorder(roleColor(for: configuration.role).opacity(0.3), lineWidth: 1)
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
            PaleBackgroundView(role: configuration.role, accentColor: roleColor(for: configuration.role))
        )
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
            return Color(red: 0.35, green: 0.78, blue: 0.62)  // Mint green
        case .error:
            return Color(red: 0.91, green: 0.45, blue: 0.47)  // Soft red
        case .warning:
            return Color(red: 0.95, green: 0.77, blue: 0.35)  // Golden yellow
        case .info:
            return Color(red: 0.40, green: 0.65, blue: 0.88)  // Sky blue
        }
    }
}

// MARK: - Private Views

private struct PaleBackgroundView: View {
    let role: ToastRole
    let accentColor: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(backgroundColor)
            .overlay(
                HStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(accentColor)
                        .frame(width: 4)
                    Spacer()
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            )
    }
    
    private var backgroundColor: Color {
        if colorScheme == .dark {
            switch role {
            case .success:
                return Color(red: 0.05, green: 0.20, blue: 0.10)
            case .error:
                return Color(red: 0.25, green: 0.10, blue: 0.10)
            case .warning:
                return Color(red: 0.20, green: 0.18, blue: 0.05)
            case .info:
                return Color(red: 0.10, green: 0.15, blue: 0.30)
            }
        } else {
            switch role {
            case .success:
                return Color(red: 0.92, green: 0.98, blue: 0.95)
            case .error:
                return Color(red: 0.99, green: 0.93, blue: 0.93)
            case .warning:
                return Color(red: 0.99, green: 0.97, blue: 0.92)
            case .info:
                return Color(red: 0.93, green: 0.96, blue: 0.99)
            }
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Pale - All Roles") {
    VStack(spacing: 16) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            PaleToastStyle().makeBody(
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

#Preview("Pale - Dark Mode") {
    VStack(spacing: 16) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            PaleToastStyle().makeBody(
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
