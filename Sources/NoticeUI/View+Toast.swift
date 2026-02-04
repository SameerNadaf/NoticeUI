import SwiftUI

// MARK: - Public Toast API

extension View {
    
    /// Presents a toast notification when the binding is non-nil.
    ///
    /// Use this modifier to display toast notifications in your app.
    /// The toast will automatically dismiss based on its duration,
    /// or can be dismissed by tapping.
    ///
    /// ## Example
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var toast: Toast?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Show Success") {
    ///                 toast = Toast(
    ///                     message: "Operation completed!",
    ///                     role: .success
    ///                 )
    ///             }
    ///         }
    ///         .toast($toast)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter toast: A binding to an optional `Toast`. When non-nil,
    ///   the toast is displayed. Set to nil to dismiss.
    /// - Returns: A view that can display toast notifications.
    public func toast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast, style: AnyToastStyle(GlassToastStyle())))
    }
    
    /// Presents a toast notification with a custom style.
    ///
    /// Use this modifier when you want to apply a specific style
    /// to the toast without affecting the global style.
    ///
    /// ## Example
    /// ```swift
    /// .toast($toast, style: VibrantToastStyle())
    /// ```
    ///
    /// - Parameters:
    ///   - toast: A binding to an optional `Toast`.
    ///   - style: The style to use for rendering the toast.
    /// - Returns: A view that can display toast notifications.
    public func toast<S: ToastStyle>(_ toast: Binding<Toast?>, style: S) -> some View {
        modifier(ToastModifier(toast: toast, style: AnyToastStyle(style)))
    }
}

