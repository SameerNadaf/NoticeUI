import SwiftUI

/// A premium liquid glass toast style.
///
/// This style replicates a modern "liquid glass" aesthetic often seen in high-end
/// iOS interfaces. It uses a combination of system materials, gradient overlays,
/// and subtle borders to create a depth-rich, glossy appearance.
///
/// ## Visual Design
/// - Heavy blur material for rich background distortion
/// - White gradient overlay for a "liquid" sheen
/// - Soft shadow matching the role color
/// - Refined typography and iconography
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
                    icon(for: configuration)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(roleColor(for: configuration.role))
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
                                    .fill(roleColor(for: configuration.role).opacity(0.15))
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
            ZStack {
                // 1. Base Material
                // Using regularMaterial for substantial blur, shape clipped
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
                
                // 2. Liquid Sheen Gradient
                // Top-left to bottom-right white gradient for "gloss"
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.25),
                                .white.opacity(0.05),
                                .white.opacity(0.0)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // 3. Border Stroke
                // Gradient stroke to simulate light hitting the top edge
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.1),
                                .black.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        // 4. Soft Colored Shadow
        // subtle glow matching the role color
        .shadow(
            color: roleColor(for: configuration.role).opacity(0.15),
            radius: 12,
            x: 0,
            y: 8
        )
        // 5. Hard Drop Shadow
        // for distinct separation
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
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
    .background(
        // Using a gradient background to demonstrate the glass effect
        LinearGradient(
            colors: [.blue, .purple, .pink],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
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
    .background(
        // Using a dark gradient background
        LinearGradient(
            colors: [.black, .gray.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
    )
    .preferredColorScheme(.dark)
}
#endif
