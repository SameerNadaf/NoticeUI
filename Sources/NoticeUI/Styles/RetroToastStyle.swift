import SwiftUI

/// A retro, terminal-inspired toast style.
///
/// This style mimics the look of old-school CRT monitors and command-line interfaces.
/// It uses a solid black background, monospaced typography, and high-contrast
/// accent colors (typically green or amber).
public struct RetroToastStyle: ToastStyle, Sendable {
    
    /// Creates a new retro toast style.
    public init() {}
    
    public func makeBody(configuration: ToastStyleConfiguration) -> some View {
        HStack(spacing: 12) {
            // Icon
            icon(for: configuration)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(roleColor(for: configuration.role))
            
            VStack(alignment: .leading, spacing: 2) {
                // Title (Role)
                Text(roleTitle(for: configuration.role).uppercased())
                    .font(.custom("Courier", size: 10))
                    .fontWeight(.bold)
                    .foregroundStyle(roleColor(for: configuration.role))
                
                // Message
                Text(configuration.message)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(roleColor(for: configuration.role))
                    .lineLimit(2)
                
                // Actions
                if !configuration.actions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(configuration.actions) { action in
                            Button(action: action.action) {
                                Text("[\(action.title.uppercased())]")
                                    .font(.system(.caption, design: .monospaced))
                                    .fontWeight(.bold)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(roleColor(for: configuration.role))
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.black)
        .overlay(
            Rectangle()
                .strokeBorder(roleColor(for: configuration.role), lineWidth: 2)
        )
        // Hard, pixelated shadow
        .shadow(color: roleColor(for: configuration.role).opacity(0.5), radius: 0, x: 4, y: 4)
    }
    
    // MARK: - Private Helpers
    
    private func icon(for configuration: ToastStyleConfiguration) -> Image {
        if let customIcon = configuration.icon {
            return Image(systemName: customIcon)
        }
        return roleIcon(for: configuration.role)
    }
    
    private func roleIcon(for role: ToastRole) -> Image {
        switch role {
        case .success:
            return Image(systemName: "checkmark.square.fill")
        case .error:
            return Image(systemName: "xmark.square.fill")
        case .warning:
            return Image(systemName: "exclamationmark.square.fill")
        case .info:
            return Image(systemName: "info.square.fill")
        }
    }
    
    private func roleTitle(for role: ToastRole) -> String {
        switch role {
        case .success: return "SUCCESS"
        case .error: return "ERROR"
        case .warning: return "WARNING"
        case .info: return "INFO"
        }
    }
    
    private func roleColor(for role: ToastRole) -> Color {
        switch role {
        case .success:
            return Color(red: 0.2, green: 1.0, blue: 0.2) // Terminal Green
        case .error:
            return Color(red: 1.0, green: 0.2, blue: 0.2) // CRT Red
        case .warning:
            return Color(red: 1.0, green: 0.8, blue: 0.0) // Amber
        case .info:
            return Color(red: 0.2, green: 0.8, blue: 1.0) // Cyan
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Retro Style") {
    VStack(spacing: 20) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            RetroToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "System process completed successfully.",
                    role: role
                )
            )
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray)
}
#endif
