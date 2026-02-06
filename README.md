[![Release](https://img.shields.io/github/v/release/SameerNadaf/NoticeUI?style=flat-square)](https://github.com/SameerNadaf/NoticeUI/releases)
![Swift](https://img.shields.io/badge/Swift-5.7%2B-orange?style=flat-square)
![Platforms](https://img.shields.io/badge/Platforms-iOS%2016%2B%20|%20macOS%2013%2B-blue?style=flat-square)

# NoticeUI

NoticeUI is a lightweight **SwiftUI toast notification and in-app messaging library**
for iOS and macOS — similar to snackbars and alerts — built entirely with SwiftUI.

It provides a clean, state-driven API for displaying beautiful, accessible, and fully
customizable toast messages without UIKit hacks.

<br/>

![NoticeUI Styles](https://github.com/SameerNadaf/Templates/blob/main/NoticeUI.png?raw=true)

<br/>

## ✨ Why NoticeUI?

- Built purely for SwiftUI (no UIKit wrappers)
- Simple state-driven API
- Accessibility-first by default
- Modern animations and gestures
- Works seamlessly on iOS & macOS
- Easy global and per-toast styling

<br/>

## 🚀 Features

- **SwiftUI Native**
- **State-Driven API**
- **Toast Roles** — success, error, warning, info
- **Flexible Placement** — top, center, bottom
- **Premium Styles**
  - `GlassToastStyle` (default frosted look)
  - `PaleToastStyle`
  - `VibrantToastStyle`
- **Swipe to Dismiss**
- **Haptic Feedback**
- **Accessibility First**
- **Cross-Platform Support**

<br/>

## 📦 Installation

### Swift Package Manager

1. In Xcode: **File → Add Packages...**
2. Enter:

```

https://github.com/SameerNadaf/NoticeUI.git

````

3. Select version: **from 1.2.2**

<br/>

## 🧑‍💻 Quick Start

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
````

> When using `NavigationStack` or `NavigationView`, apply the `.toast()` modifier **outside** the navigation container. This ensures the toast appears above the navigation bar.
>
> ```swift
> NavigationStack {
>    // Content
> }
> .toast($toast)
> ```

<br/>

## ⚙️ Full Configuration

```swift
Toast(
    message: "Network error occurred",
    role: .error,
    icon: "wifi.slash",
    placement: .top,
    duration: .long,
    haptic: .error
)
```

### Supported Roles

* `.success`
* `.error`
* `.warning`
* `.info`

### Supported Durations

* `.short` (2s)
* `.long` (4s)
* `.custom(TimeInterval)`
* `.indefinite`

<br/>

## 🎨 Styling

### Glass (Default)

```swift
.toast($toast, style: GlassToastStyle())
```

### Vibrant

```swift
.toast($toast, style: VibrantToastStyle())
```

### Pale

```swift
.toast($toast, style: PaleToastStyle())
```

### Global Style

Apply a style to an entire view hierarchy using the environment.

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

<br/>

## 🤏 Interactions

**Swipe to dismiss**

| Placement | Gesture          |
| --------- | ---------------- |
| Top       | Swipe up         |
| Bottom    | Swipe down       |
| Center    | Swipe left/right |

<br/>

## 📳 Haptic Feedback

Built-in feedback system:

* Automatic by role
* Success, error, warning
* Light / medium / heavy

<br/>

## ♿ Accessibility

NoticeUI is designed for real-world accessibility:

* VoiceOver announcements
* Role-aware context
* Reduce Motion support
* Dynamic Type scaling
* Extended display time when VoiceOver is active

<br/>

## 🚫 When Not to Use

* If you need system notifications
* If you support iOS below 16
* If you rely heavily on UIKit overlays

<br/>

## 📋 Requirements

* iOS 16.0+
* macOS 13.0+
* Swift 5.7+

<br/>

## 📄 License

MIT License — see [LICENSE](LICENSE)
