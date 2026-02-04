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
                    roleIcon(for: configuration.role)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                )
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(roleTitle(for: configuration.role))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                
                Text(configuration.message)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(roleColor(for: configuration.role))
        )
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
    .background(Color(.systemBackground))
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
    .background(Color(.systemBackground))
    .preferredColorScheme(.dark)
}
#endif
