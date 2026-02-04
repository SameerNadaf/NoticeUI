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
                    roleIcon(for: configuration.role)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
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
                .fill(roleColor(for: configuration.role).opacity(0.12))
                .overlay(
                    HStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(roleColor(for: configuration.role))
                            .frame(width: 4)
                        Spacer()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                )
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
