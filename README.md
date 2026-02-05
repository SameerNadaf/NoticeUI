[![Release](https://img.shields.io/github/v/release/SameerNadaf/NoticeUI)](https://github.com/SameerNadaf/NoticeUI/releases)
![Swift](https://img.shields.io/badge/Swift-5.7-orange)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%2B%20|%20macOS%2013%2B-blue)

# NoticeUI

A production-quality, pure SwiftUI Toast library for iOS and macOS. NoticeUI provides a clean, state-driven API for displaying beautiful, accessible, and customizable toast notifications.

![NoticeUI Styles](https://github.com/SameerNadaf/Templates/blob/main/NoticeUI.png?raw=true)

## Features

- **SwiftUI Native**: Built entirely with SwiftUI for seamless integration.
- **State-Driven API**: Manage toasts using a simple `@State` binding.
- **Multiple Roles**: Built-in support for `success`, `error`, `warning`, and `info` roles.
- **Flexible Placement**: Position toasts at `top`, `center`, or `bottom`.
- **Beautiful Styles**: Includes 3 premium built-in styles:
  - `GlassToastStyle` (Default)
  - `PaleToastStyle`
  - `VibrantToastStyle`
- **Interactive**: Swipe to dismiss support (placement-aware).
- **Haptic Feedback**: Meaningful haptic feedback for different notification types.
- **Accessibility First**: Full VoiceOver support, accessible announcements, and Reduce Motion usage.
- **Cross-Platform**: Supports iOS 16+ and macOS 13+.

## Installation

### Swift Package Manager

Add `NoticeUI` to your project via Swift Package Manager:

1. In Xcode, go to **File > Add Packages...**
2. Enter the repository URL: `https://github.com/SameerNadaf/NoticeUI.git`
3. Select the version (e.g., `1.0.0` or `main`)
4. Add the `NoticeUI` product to your target.

## Usage

### Basic Example

1. Import `NoticeUI`
2. Create a `@State` property for your toast
3. Use the `.toast($toast)` modifier

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

> [!TIP]
> When using `NavigationStack` or `NavigationView`, apply the `.toast()` modifier **outside** the navigation container. This ensures the toast appears above the navigation bar.
>
> ```swift
> NavigationStack {
>    // Content
> }
> .toast($toast) // Correct placement
> ```

### Full Configuration

You can customize the toast role, icon, duration, placement, and haptic feedback:

```swift
Toast(
    message: "Network error occurred",
    role: .error,
    icon: "wifi.slash",        // Custom SF Symbol
    placement: .top,
    duration: .long,           // 4 seconds
    haptic: .error             // Triggers error haptic feedback
)
```

**Supported Roles:**

- `.success`
- `.error`
- `.warning`
- `.info`

**Supported Durations:**

- `.short` (2s)
- `.long` (4s)
- `.custom(TimeInterval)`
- `.indefinite` (Explicit dismissal required)

### Styling

NoticeUI comes with three built-in styles. You can apply a style globally or to a specific toast.

**1. Glass Style (Default)**
A translucent, frosted-glass look.

```swift
.toast($toast, style: GlassToastStyle())
```

**2. Vibrant Style**
High-contrast, solid background colors. Best for critical alerts.

```swift
.toast($toast, style: VibrantToastStyle())
```

**3. Pale Style**
Subtle, light background with a role-colored accent border.

```swift
.toast($toast, style: PaleToastStyle())
```

### Global Styling

Apply a style to an entire view hierarchy using the environment:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .toastStyle(VibrantToastStyle()) // All toasts in app will use Vibrant style
        }
    }
}
```

## Interactive Features

### Swipe to Dismiss

Toasts support swipe gestures to dismiss them early:

- **Top placement**: Swipe UP to dismiss
- **Bottom placement**: Swipe DOWN to dismiss
- **Center placement**: Swipe LEFT or RIGHT to dismiss

### Haptic Feedback

NoticeUI includes a `ToastHapticFeedback` system that can trigger haptics when a toast appears.

- `.success`: Light impact followed by heavy impact
- `.error`: Series of heavy impacts
- `.warning`: Medium impact
- `.light`, `.medium`, `.heavy`: Standard impacts
- `.automatic`: Automatically picks the haptic based on the toast role

## Accessibility

NoticeUI is built with accessibility as a priority:

- **VoiceOver**: Automatically announces (or "speaks") the toast message when it appears.
- **Role Context**: Announcements include the role (e.g., "Error: Network failed") for context.
- **Reduce Motion**: Respects the user's "Reduce Motion" system setting by using simpler fade animations instead of slides.
- **Dynamic Type**: Supports dynamic text scaling.
- **Time Extension**: Automatically extends specific durations (1.5x) when VoiceOver is active to give users more time to read.

## Requirements

- iOS 16.0+
- macOS 13.0+
- Swift 5.7+

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
