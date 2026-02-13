//
//  ContentView.swift
//  NoticeUIDemo
//
//  Created by Sameer Nadaf on 04/02/26.
//

import SwiftUI
import NoticeUI

struct ContentView: View {
    @State private var toast: Toast?
    @State private var selectedStyle: ToStringStyle = .pale
    @State private var placement: ToastPlacement = .top
    @State private var selectedDuration: DemoDuration = .short
    @State private var selectedQueueMode: ToastQueueMode = .fifo
    @State private var showCustomIcon: Bool = false
    @State private var showAction: Bool = false
    @State private var useHaptics: Bool = true

    enum ToStringStyle: String, CaseIterable, Identifiable {
        case glass = "Glass"
        case pale = "Pale"
        case vibrant = "Vibrant"
        case capsule = "Capsule"
        case retro = "Retro"
        case notification = "Notification"
        
        var id: String { rawValue }
    }
    
    enum DemoDuration: String, CaseIterable, Identifiable {
        case short = "Short (2s)"
        case long = "Long (4s)"
        case everlasting = "Indefinite"
        
        var id: String { rawValue }
        
        var value: ToastDuration {
            switch self {
            case .short: return .short
            case .long: return .long
            case .everlasting: return .indefinite
            }
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Configuration") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Style")
                        
                        Picker("Style Row 1", selection: $selectedStyle) {
                            ForEach(Array(ToStringStyle.allCases.prefix(3))) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        Picker("Style Row 2", selection: $selectedStyle) {
                            ForEach(Array(ToStringStyle.allCases.dropFirst(3))) { style in
                                Text(style.rawValue).tag(style)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Picker("Placement", selection: $placement) {
                        Text("Top").tag(ToastPlacement.top)
                        Text("Center").tag(ToastPlacement.center)
                        Text("Bottom").tag(ToastPlacement.bottom)
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Duration", selection: $selectedDuration) {
                        ForEach(DemoDuration.allCases) { duration in
                            Text(duration.rawValue).tag(duration)
                        }
                    }
                    
                    Picker("Queue Mode", selection: $selectedQueueMode) {
                        Text("FIFO").tag(ToastQueueMode.fifo)
                        Text("Replace").tag(ToastQueueMode.replaceAll)
                        Text("Priority").tag(ToastQueueMode.priority)
                    }
                    .pickerStyle(.segmented)
                    
                    Toggle("Use Custom Icon", isOn: $showCustomIcon)
                    Toggle("Add Action", isOn: $showAction)
                    Toggle("Haptic Feedback", isOn: $useHaptics)
                }
                
                Section("Triggers") {
                    Button {
                        showToast(
                            message: "Operation completed successfully",
                            role: .success,
                        )
                    } label: {
                        Label("Show Success", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                    
                    Button {
                        showToast(
                            message: "Network connection lost",
                            role: .error
                        )
                    } label: {
                        Label("Show Error", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                    
                    Button {
                        showToast(
                            message: "Storage is running low",
                            role: .warning
                        )
                    } label: {
                        Label("Show Warning", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                    }
                    
                    Button {
                        showToast(
                            message: "Update available",
                            role: .info
                        )
                    } label: {
                        Label("Show Info", systemImage: "info.circle.fill")
                            .foregroundStyle(.blue)
                    }
                }
                
                Section("Queue Demo") {
                    Button {
                        showToast(message: "Step 1: Downloading...", role: .info)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            showToast(message: "Step 3: Complete!", role: .success)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            showToast(message: "Step 2: Processing...", role: .warning)
                        }
                    } label: {
                        Label("Queue 3 Toasts", systemImage: "arrow.triangle.2.circlepath")
                            .foregroundStyle(.purple)
                    }
                    
                    Text("Fires 3 toasts in rapid succession. Watch them appear one after another based on queue mode.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("NoticeUI Demo")
        }
        .toast($toast, style: currentStyle, queueMode: selectedQueueMode)
    }
    
    private func showToast(message: String, role: ToastRole) {
        var actions: [ToastAction] = []
        
        if showAction {
            actions.append(
                ToastAction(title: "Undo") {
                    print("Undo tapped for \(message)")
                }
            )
            
            // Add a second action for error role to demonstrate multiple actions
            if role == .error {
                actions.append(
                    ToastAction(title: "Retry") {
                        print("Retry tapped")
                    }
                )
            }
        }
        
        toast = Toast(
            message: message,
            role: role,
            icon: showCustomIcon ? "star.fill" : nil,
            placement: placement,
            duration: selectedDuration.value,
            haptic: useHaptics ? .automatic : .none,
            actions: actions
        )
    }
    
    private var currentStyle: AnyToastStyle {
        switch selectedStyle {
        case .glass:
            return AnyToastStyle(GlassToastStyle())
        case .pale:
            return AnyToastStyle(PaleToastStyle())
        case .vibrant:
            return AnyToastStyle(VibrantToastStyle())
        case .capsule:
            return AnyToastStyle(CapsuleToastStyle())
        case .retro:
            return AnyToastStyle(RetroToastStyle())
        case .notification:
            return AnyToastStyle(NotificationToastStyle())
        }
    }
}

#Preview {
    ContentView()
}
