import SwiftUI

/// A type that defines the appearance of a toast.
///
/// You create custom toast styles by conforming to this protocol and
/// implementing the `makeBody(configuration:)` method. The pattern
/// follows SwiftUI's `ButtonStyle` convention.
///
/// ## Creating a Custom Style
/// ```swift
/// struct MyCustomToastStyle: ToastStyle {
///     func makeBody(configuration: ToastStyleConfiguration) -> some View {
///         HStack {
///             Image(systemName: "star.fill")
///             Text(configuration.message)
///         }
///         .padding()
///         .background(Color.yellow)
///         .cornerRadius(8)
///     }
/// }
/// ```
///
/// ## Using a Custom Style
/// ```swift
/// .toast($toast, style: MyCustomToastStyle())
/// ```
public protocol ToastStyle: Sendable {
    /// The type of view returned by `makeBody`.
    associatedtype Body: View
    
    /// Creates a view representing the toast.
    /// - Parameter configuration: The properties of the toast being rendered.
    /// - Returns: A view that represents the toast.
    @ViewBuilder func makeBody(configuration: ToastStyleConfiguration) -> Body
}

// MARK: - Environment Key for Toast Style

/// Type-erased wrapper for ToastStyle to enable environment storage.
struct AnyToastStyle: ToastStyle {
    private let _makeBody: @Sendable (ToastStyleConfiguration) -> AnyView
    
    init<S: ToastStyle>(_ style: S) {
        self._makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    func makeBody(configuration: ToastStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}

/// Environment key for the current toast style.
struct ToastStyleKey: EnvironmentKey {
    static let defaultValue: AnyToastStyle = AnyToastStyle(GlassToastStyle())
}

extension EnvironmentValues {
    /// The toast style to use when rendering toasts.
    var toastStyle: AnyToastStyle {
        get { self[ToastStyleKey.self] }
        set { self[ToastStyleKey.self] = newValue }
    }
}

// MARK: - View Extension for Setting Style

extension View {
    /// Sets the toast style for this view and its descendants.
    /// - Parameter style: The toast style to use.
    /// - Returns: A view with the toast style set.
    public func toastStyle<S: ToastStyle>(_ style: S) -> some View {
        environment(\.toastStyle, AnyToastStyle(style))
    }
}
