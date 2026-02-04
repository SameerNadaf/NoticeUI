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
            roleIcon(for: configuration.role)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(roleColor(for: configuration.role))
            
            Text(configuration.message)
                .font(.subheadline)
                .foregroundStyle(.primary)
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
            return Image(systemName: "checkmark.circle.fill")
        case .error:
            return Image(systemName: "xmark.circle.fill")
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
        case .info:
            return Image(systemName: "info.circle.fill")
        }
    }
    
    private func roleColor(for role: ToastRole) -> Color {
        switch role {
        case .success:
            return .green
        case .error:
            return .red
        case .warning:
            return .orange
        case .info:
            return .blue
        }
    }
}
