import SwiftUI

// MARK: - Public Toast API

extension View {
    
    /// Presents a toast notification when the binding is non-nil.
    ///
    /// Use this modifier to display toast notifications in your app.
    /// The toast will automatically dismiss based on its duration,
    /// or can be dismissed by swiping.
    ///
    /// When multiple toasts are triggered, they are queued and shown
    /// one at a time using the default FIFO (first-in, first-out) order.
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
    ///   the toast is enqueued for display. The binding is reset to `nil`
    ///   after the toast is consumed by the queue.
    /// - Returns: A view that can display toast notifications.
    public func toast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast, style: AnyToastStyle(GlassToastStyle()), queueMode: .fifo))
    }
    
    /// Presents a toast notification with a custom style.
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
        modifier(ToastModifier(toast: toast, style: AnyToastStyle(style), queueMode: .fifo))
    }
    
    /// Presents a toast notification with a specific queue mode.
    ///
    /// Use this to control how multiple toasts are handled:
    /// - `.fifo`: Toasts queue up and show one after another (default).
    /// - `.replaceAll`: New toast immediately replaces the current one and clears the queue.
    /// - `.priority`: Toasts are reordered by severity (error > warning > success > info).
    ///
    /// ## Example
    /// ```swift
    /// .toast($toast, queueMode: .priority)
    /// ```
    ///
    /// - Parameters:
    ///   - toast: A binding to an optional `Toast`.
    ///   - queueMode: The queue behavior to use. Defaults to `.fifo`.
    /// - Returns: A view that can display toast notifications.
    public func toast(_ toast: Binding<Toast?>, queueMode: ToastQueueMode) -> some View {
        modifier(ToastModifier(toast: toast, style: AnyToastStyle(GlassToastStyle()), queueMode: queueMode))
    }
    
    /// Presents a toast notification with a custom style and queue mode.
    ///
    /// ## Example
    /// ```swift
    /// .toast($toast, style: RetroToastStyle(), queueMode: .priority)
    /// ```
    ///
    /// - Parameters:
    ///   - toast: A binding to an optional `Toast`.
    ///   - style: The style to use for rendering the toast.
    ///   - queueMode: The queue behavior to use. Defaults to `.fifo`.
    /// - Returns: A view that can display toast notifications.
    public func toast<S: ToastStyle>(_ toast: Binding<Toast?>, style: S, queueMode: ToastQueueMode) -> some View {
        modifier(ToastModifier(toast: toast, style: AnyToastStyle(style), queueMode: queueMode))
    }
}
