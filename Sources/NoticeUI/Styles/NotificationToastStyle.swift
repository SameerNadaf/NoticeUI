import SwiftUI

/// A toast style that mimics the native iOS notification banner.
///
/// This style features a distinct header with an icon and title, followed by
/// the main message body. It replicates the look standard system notifications.
public struct NotificationToastStyle: ToastStyle, Sendable {
    
    /// Creates a new notification toast style.
    public init() {}
    
    public func makeBody(configuration: ToastStyleConfiguration) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            // Header: Icon + Title + Timestamp
            HStack(spacing: 6) {
                // Small Icon
                icon(for: configuration)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundStyle(roleColor(for: configuration.role))
                
                // Title
                Text(roleTitle(for: configuration.role).uppercased())
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                // "Now" timestamp
                Text("now")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            
            // Body Message
            Text(configuration.message)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(3)
            
            // Actions
            if !configuration.actions.isEmpty {
                HStack(spacing: 8) {
                    ForEach(configuration.actions) { action in
                        Button(action: action.action) {
                            Text(action.title)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(roleColor(for: configuration.role))
                        .background(
                            Capsule()
                                .fill(roleColor(for: configuration.role).opacity(0.1))
                        )
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
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
            return Image(systemName: "checkmark.circle.fill")
        case .error:
            return Image(systemName: "xmark.circle.fill")
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .info:
            return Image(systemName: "info.circle.fill")
        }
    }
    
    private func roleTitle(for role: ToastRole) -> String {
        switch role {
        case .success: return "Success"
        case .error: return "Error"
        case .warning: return "Warning"
        case .info: return "Info"
        }
    }
    
    private func roleColor(for role: ToastRole) -> Color {
        switch role {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Notification Style") {
    VStack(spacing: 20) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            NotificationToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "This is a notification style toast that looks like a system banner.",
                    role: role
                )
            )
            .padding(.horizontal)
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.2))
}
#endif
