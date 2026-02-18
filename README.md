[![Release](https://img.shields.io/github/v/release/SameerNadaf/NoticeUI?style=flat-square)](https://github.com/SameerNadaf/NoticeUI/releases)
![Swift](https://img.shields.io/badge/Swift-5.7%2B-orange?style=flat-square)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%2B%20|%20macOS%2013%2B-blue?style=flat-square)

# NoticeUI

**NoticeUI** is a fully SwiftUI-native toast and in-app notification framework for iOS and macOS, designed around predictable state management and built-in queue handling.

Unlike libraries that rely on UIKit overlays or fragile view hierarchies, NoticeUI integrates directly into SwiftUI using bindings, environment values, and view modifiers — ensuring clean architecture, smooth animations, and reliable presentation.

From quick success messages to interactive actions like **Undo**, or fully custom designs, NoticeUI provides a flexible, state-driven API with multiple queue modes to handle real-world messaging flows without extra glue code.

<br/>

![NoticeUI Banner](https://github.com/SameerNadaf/Templates/blob/main/NoticeUI.png?raw=true)

<br/>

## ✨ Why NoticeUI?

- **SwiftUI Native**: Built purely for SwiftUI using `ViewModifier` and `Environment`.
- **State-Driven**: Control presentation with a simple optional Binding (`$toast`).
- **Interactive**: Support for action buttons in all styles.
- **Accessible**: VoiceOver support, Dynamic Type, and Reduce Motion awareness built-in.
- **Premium Styles**: 6+ high-quality built-in styles.
- **Customizable**: Create your own unique toast styles easily.
- **Haptics**: Automatic haptic feedback based on toast roles.
- **Queue Management**: Built-in FIFO (default), `replaceAll`, and `priority` modes with predictable ordering and immediate binding reset after enqueue.

<br/>

## 🚀 Features

- **Toast Roles** — `.success`, `.error`, `.warning`, `.info`
- **Flexible Placement** — `.top`, `.center`, `.bottom`
- **Interactive Actions** — Add buttons to any toast
- **Swipe to Dismiss** — Intuitive gesture support
- **Queue Management** — FIFO, replaceAll, priority
- **Rich Styles** — Glass, Vibrant, Pale, Capsule, Retro, Notification
- **Cross-Platform** — Seamless on iOS & macOS
- **Haptic Feedback** — Automatic and customizable vibration patterns
- **Flexible Duration** — Short, long, indefinite, or custom time intervals
- **Accessibility** — Built-in VoiceOver support and Dynamic Type scaling
- **Localization** — Native `LocalizedStringKey` support for multi-language apps

<br/>

## 📦 Installation

### Swift Package Manager

1. In Xcode: **File → Add Packages...**
2. Enter: `https://github.com/SameerNadaf/NoticeUI.git`
3. Select version: **from 1.4.0**

<br/>

## 🧑‍💻 Quick Start

1. Import `NoticeUI`.
2. Create a `@State` property for your toast.
3. Use the `.toast($toast)` modifier.

```swift
import SwiftUI
import NoticeUI

struct ContentView: View {
    @State private var toast: Toast?

    var body: some View {
        Button("Show Success") {
            toast = Toast(message: "Operation completed!", role: .success)
        }
        .toast($toast)
    }
}
```

> **Tip:** When using `NavigationStack` or `NavigationView`, apply the `.toast()` modifier **outside** the navigation container. This ensures the toast appears above the navigation bar.
>
> ```swift
> NavigationStack {
>    // Content
> }
> .toast($toast)
> ```
>
> **Note:** By default, toasts are enqueued (FIFO). The binding is reset to `nil` immediately after enqueue so you can trigger again without extra state handling.

<br/>

## 🏷 Titles

Toasts can have a custom title, automatically use the role title (default), or have no title at all.

```swift
// Default: Uses role title (e.g., "Success", "Error")
Toast(message: "Operation completed")

// Custom Title
Toast(title: "Saved", message: "Your changes have been saved")

// No Title
Toast(title: nil, message: "Just a message")
```

> **Note:** Use `nil` to hide the title completely. If you omit the parameter, it defaults to `.automatic`.

<br/>

## 🌍 Localization

NoticeUI supports `LocalizedStringKey` natively, just like SwiftUI's `Text`.

### Localized Strings

If you pass a string literal or a `LocalizedStringKey`, NoticeUI will attempt to localize it using your app's `Localizable.strings` (or `.xcstrings`).

```swift
// Automatically looks up "operation_completed" key
Toast(message: "operation_completed", role: .success)

// Explicit LocalizedStringKey
let key: LocalizedStringKey = "error_network"
Toast(message: key, role: .error)
```

### Dynamic Strings

If you pass a `String` variable or interpolation, it is treated as a raw string and **not** localized.

```swift
// Renders exactly as provided (no lookup)
let userName = "Alice"
Toast(message: "Hello, \(userName)", role: .info)
```

### Localized Actions & Titles

Localization works for titles and actions too:

```swift
Toast(
    title: "save_success",  // Localized key
    message: "data_saved_message", // Localized key
    actions: [
        ToastAction(title: "undo_action") { } // Localized button title
    ]
)
```

<br/>

## ⚙️ Full Configuration

The `Toast` struct offers powerful configuration options:

```swift
Toast(
    title: "Connection Failed",
    message: "Network error occurred",
    role: .error,
    icon: "wifi.slash",
    placement: .top,
    duration: .long,
    haptic: .error,
    actions: [
        ToastAction(title: "Retry") {
            // Retry logic
        }
    ]
)
```

### Supported Roles

- `.success`
- `.error`
- `.warning`
- `.info`

### Supported Placement

- `.top`
- `.center`
- `.bottom`

### Supported Durations

- `.short` (2s)
- `.long` (4s)
- `.custom(TimeInterval)`
- `.indefinite`

### Supported Haptics

- `.automatic` (default)
- `.success`
- `.warning`
- `.error`
- `.light`
- `.medium`
- `.heavy`
- `.none`

<br/>

## 🚦 Queue Management

Control how multiple toasts are handled when triggered in quick succession.

### Queue Modes

| Mode              | Description                                                                                |
| :---------------- | :----------------------------------------------------------------------------------------- |
| **`.fifo`**       | Default. Toasts are shown one by one in the order they were added.                         |
| **`.replaceAll`** | Immediate. The new toast replaces the current one and clears the queue.                    |
| **`.priority`**   | Smart. Critical messages jump to the front (`.error` > `.warning` > `.success` > `.info`). |

### Usage

```swift
// Standard FIFO behavior
.toast($toast, queueMode: .fifo)

// Immediate replacement (useful for live status updates)
.toast($toast, queueMode: .replaceAll)

// Priority-based (Errors shown first)
.toast($toast, queueMode: .priority)
```

### Examples

```swift
// Example: Rapid triggers (FIFO)
struct ExampleFIFO: View {
    @State private var toast: Toast?
    var body: some View {
        VStack {
            Button("Trigger 1") { toast = Toast(message: "Info 1", role: .info) }
            Button("Trigger 2") { toast = Toast(message: "Info 2", role: .info) }
            Button("Trigger 3") { toast = Toast(message: "Info 3", role: .info) }
        }
        .toast($toast, queueMode: .fifo)
    }
}
```

```swift
// Example: Live status (replaceAll)
struct ExampleReplaceAll: View {
    @State private var toast: Toast?
    var body: some View {
        VStack {
            Button("Loading…") { toast = Toast(message: "Loading", role: .info) }
            Button("Connected") { toast = Toast(message: "Connected", role: .success) }
        }
        .toast($toast, queueMode: .replaceAll)
    }
}
```

```swift
// Example: Mixed severity (priority)
struct ExamplePriority: View {
    @State private var toast: Toast?
    var body: some View {
        VStack {
            Button("Info") { toast = Toast(message: "FYI", role: .info) }
            Button("Warning") { toast = Toast(message: "Heads up", role: .warning) }
            Button("Error") { toast = Toast(message: "Failed to save", role: .error) }
        }
        .toast($toast, queueMode: .priority)
    }
}
```

### Behavior Notes

- Each `Toast` has a unique ID to preserve queue order.
- The binding is consumed and reset to `nil` after enqueueing.
- Priority mode preserves insertion order within the same role.
- A brief visual pause (~0.2s) occurs between toasts.
- Dismiss animation completes (~0.35s) before showing the next toast.

<br/>

## 🔘 Interactive Actions

Add actionable buttons to your toasts to let users respond immediately.

```swift
Toast(
    message: "Email archived",
    role: .info,
    actions: [
        ToastAction(title: "Undo") {
            archiveService.undo()
        }
    ]
)
```

> **Note:** Actions are completely optional. If you don't provide any actions, the toast will render in its standard non-interactive form.

Interactive toasts work with **all styles**, adapting the button appearance to match the style's aesthetic:

- **Glass**: Subtle buttons with glass background
- **Vibrant**: High-contrast buttons on solid background
- **Pale**: Bordered buttons matching the role color
- **Capsule**: Inline horizontal buttons (perfect for compact actions)
- **Notification**: Buttons below the message
- **Retro**: Terminal-style command buttons

<br/>

## 🎨 Styles

NoticeUI comes with beautiful built-in styles. You can set them per-view or globally.

### Usage

```swift
// Apply to a specific view
.toast($toast, style: GlassToastStyle())

// Apply globally in your App struct
WindowGroup {
    ContentView()
        .toastStyle(VibrantToastStyle())
}
```

### Available Styles

| Style                        | Description                                                          |
| :--------------------------- | :------------------------------------------------------------------- |
| **`GlassToastStyle`**        | User-favorite. Frosted glass effect with subtle gradients. (Default) |
| **`VibrantToastStyle`**      | High-contrast, solid colors. Great for errors/warnings.              |
| **`PaleToastStyle`**         | Soft backgrounds with colored accents. Good for non-intrusive info.  |
| **`CapsuleToastStyle`**      | Compact, pill-shaped dark mode style. System-like.                   |
| **`NotificationToastStyle`** | Mimics the native iOS notification banner look.                      |
| **`RetroToastStyle`**        | Monospaced font, neon colors, and terminal aesthetics.               |

<br/>

## 🛠 Advanced Customization

### Custom Styles

You can create your own style by conforming to `ToastStyle`. It works just like SwiftUI's `ButtonStyle`.

```swift
struct MyCustomStyle: ToastStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: "star.fill")
            Text(configuration.message)
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(8)
    }
}
```

<br/>

## 🤏 Interactions

**Swipe to dismiss** is enabled by default. The gesture direction depends on the placement:

- **Top**: Swipe Up
- **Bottom**: Swipe Down
- **Center**: Swipe Left or Right

**Tap for actions**: If a toast has interactive buttons, tapping them will trigger the action. Tapping the toast body does nothing by default to prevent accidental dismissals.
Actions automatically dismiss the toast after the action completes.

<br/>

## 📳 Haptic Feedback

NoticeUI includes a sophisticated haptic feedback system that enhances the user experience:

- **Automatic**: Plays feedback matching the toast's role.
- **Customizable**: Override the default behavior or disable it entirely.

| Role        | Automatic Feedback                          |
| :---------- | :------------------------------------------ |
| **Success** | `UINotificationFeedbackGenerator(.success)` |
| **Error**   | `UINotificationFeedbackGenerator(.error)`   |
| **Warning** | `UINotificationFeedbackGenerator(.warning)` |
| **Info**    | `UIImpactFeedbackGenerator(style: .light)`  |

You can also manually specify:

- `.light`, `.medium`, `.heavy` (Impact)
- `.success`, `.warning`, `.error` (Notification)
- `.none`

You can override this per-toast:

```swift
Toast(
    message: "Data synced",
    role: .info,
    haptic: .success // Plays success haptic despite being an info toast
)
```

<br/>

## ♿ Accessibility

NoticeUI is built with accessibility in mind:

- **VoiceOver**: Toasts are announced automatically as alerts.
- **Duration Extension**: When VoiceOver is active, toast durations are extended to ensure announcements complete.
- **Reduce Motion**: Animations are disabled/simplified when "Reduce Motion" is on.
- **Dynamic Type**: Text scales with system font size settings.
- **Contrast**: Default styles are checked for readability.

<br/>

## ⚠️ Considerations

NoticeUI is an **in-app** messaging system. It is not a replacement for:

- **Push Notifications**: If you need to reach users when the app is closed.
- **System Alerts**: If you need to override the ringer switch or display critical OS-level warnings.
- **Legacy iOS**: NoticeUI requires **iOS 16+** to leverage modern SwiftUI 4.0 features.

<br/>

## 📋 Requirements

- iOS 16.0+
- macOS 13.0+
- Swift 5.7+

<br/>

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
