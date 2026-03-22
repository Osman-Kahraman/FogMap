//
//  LoadingView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-21.
//

import SwiftUI

struct LoadingView: View {

    @State private var animate = false
    @State private var expand = false
    @State private var messageIndex = 0

    private let messages = [
        "Locating you in the fog…",
        "Unlocking the map…",
        "Scanning the unknown…",
        "Revealing hidden places…"
    ]
    
    var body: some View {
        
        ZStack {

            Color.black.ignoresSafeArea()

            // Fog
            Circle()
                .fill(Color.black)
                .frame(width: expand ? 1200 : 0, height: expand ? 1200 : 0)
                .blendMode(.destinationOut)
                .animation(
                    .easeInOut(duration: 1.2),
                    value: expand
                )

            // Location
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .scaleEffect(animate ? 2.5 : 0.9)
                .animation(
                    .easeInOut(duration: 1.6)
                    .repeatForever(autoreverses: true),
                    value: animate
                )
                .opacity(expand ? 0 : 1)
                .animation(.easeOut(duration: 0.3), value: expand)
            
            // -
            Circle()
                .fill(Color.white)
                .frame(width: 26, height: 26)
                .opacity(expand ? 0 : 1)
                .animation(.easeOut(duration: 0.3), value: expand)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 19, height: 19)
                .opacity(expand ? 0 : 1)
                .animation(.easeOut(duration: 0.3), value: expand)
            
            VStack {
                Spacer()
                
                Text(messages[messageIndex])
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 60)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.4), value: messageIndex)
            }
        }
        .compositingGroup()
        .onAppear {
            animate = true

            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                messageIndex = (messageIndex + 1) % messages.count
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                expand = true
            }
        }
    }
}

#Preview {
    LoadingView()
}
