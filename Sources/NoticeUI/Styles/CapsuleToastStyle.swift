import SwiftUI

/// A system-like capsule toast style.
///
/// This style mimics the compact, pill-shaped notifications often seen in
/// system interfaces (e.g., "Silent Mode", "Added to Library").
/// It features a high-contrast dark appearance with a blur effect.
public struct CapsuleToastStyle: ToastStyle, Sendable {
    
    /// Creates a new capsule toast style.
    public init() {}
    
    public func makeBody(configuration: ToastStyleConfiguration) -> some View {
        HStack(spacing: 12) {
            // Icon
            icon(for: configuration)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
            
            // Message
            Text(configuration.message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)
                .lineLimit(2)
            
            // Actions
            if !configuration.actions.isEmpty {
                
                Spacer(minLength: 4)

                HStack(spacing: 8) {
                    ForEach(configuration.actions) { action in
                        Button(action: action.action) {
                            Text(action.title)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.white)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Capsule(style: .continuous)
                .fill(.regularMaterial)
                .colorScheme(.dark) // Force dark appearance for contrast
        )
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
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
            return Image(systemName: "checkmark")
        case .error:
            return Image(systemName: "exclamationmark.triangle")
        case .warning:
            return Image(systemName: "exclamationmark")
        case .info:
            return Image(systemName: "info.circle")
        }
    }
}

// MARK: - Previews

#if DEBUG
#Preview("Capsule Style") {
    VStack(spacing: 20) {
        ForEach([ToastRole.success, .error, .warning, .info], id: \.self) { role in
            CapsuleToastStyle().makeBody(
                configuration: ToastStyleConfiguration(
                    message: "System notification message",
                    role: role
                )
            )
        }
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray.opacity(0.2))
}
#endif
