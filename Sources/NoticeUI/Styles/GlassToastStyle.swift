import SwiftUI

/// A glass-like toast style using system materials.
///
/// This style provides a translucent background with the system's
/// ultra-thin material, giving a frosted glass appearance. The role
/// is indicated by a subtle accent color.
public struct GlassToastStyle: ToastStyle, Sendable {
    
    /// Creates a new glass toast style.
    public init() {}
    
    public func makeBody(configuration: ToastStyleConfiguration) -> some View {
        HStack(spacing: 12) {
            // Icon circle with role color background
            Circle()
                .fill(roleColor(for: configuration.role).opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    roleIcon(for: configuration.role)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(roleColor(for: configuration.role))
                )
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(roleTitle(for: configuration.role))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Text(configuration.message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(roleColor(for: configuration.role).opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Private Helpers
    
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
    
    private func roleTitle(for role: ToastRole) -> String {
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

// MARK: - Previews

#if DEBUG
#Preview("Glass - All Roles") {
    VStack(spacing: 16) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            GlassToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "This is a \(String(describing: role)) message",
                    role: role
                )
            )
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
}

#Preview("Glass - Dark Mode") {
    VStack(spacing: 16) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            GlassToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "This is a \(String(describing: role)) message",
                    role: role
                )
            )
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
#endif
