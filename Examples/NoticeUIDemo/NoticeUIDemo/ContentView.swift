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
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Sucess") {
                toast = Toast(message: "Sucess toast shown", role: .success, placement: .top, duration: .short)
            }
            Button("Show Warning") {
                toast = Toast(message: "Warning toast shown", role: .warning, placement: .bottom, duration: .long)
            }
            Button("Show Error") {
                toast = Toast(message: "Error toast shown", role: .error, placement: .top, duration: .custom(1.0))
            }
            Button("Show Info") {
                toast = Toast(message: "Info toast shown", role: .info, placement: .center, duration: .indefinite)
            }
        }
        .toast($toast, style: PaleToastStyle())
        .padding()
    }
}

#Preview {
    ContentView()
}
