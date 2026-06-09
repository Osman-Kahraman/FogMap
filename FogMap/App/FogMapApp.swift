//
//  FogMapApp.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-14.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import UIKit

@main
struct FogMapApp: App {
    @StateObject var authManager = AuthManager()
    @AppStorage("appTheme") private var appTheme: String = "Dark"
    @State private var showLoading = false
    @State private var allowContent = false
    @State private var showContentInAnimation = false
    @State private var playContentInAnimation = false

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {

        WindowGroup {
            ZStack {
                if authManager.isLoggedIn {
                    if allowContent {
                        ContentView()
                            .environmentObject(authManager)
                    } else {
                        Color.black.ignoresSafeArea()
                    }
                } else {
                    LoginView()
                        .environmentObject(authManager)
                }

                if showLoading {
                    LoadingView()
                        .zIndex(10)
                        .transition(.opacity)
                }

                if showContentInAnimation {
                    InAnimationView(play: playContentInAnimation)
                        .zIndex(11)
                        .transition(.opacity)
                }
            }
            .onChange(of: authManager.isLoggedIn) { oldValue, newValue in
                if newValue {
                    showLoading = true
                    allowContent = false

                    Task {
                        try? await Task.sleep(nanoseconds: 7_400_000_000)

                        await MainActor.run {
                            allowContent = true
                            playContentInAnimation = false
                            showContentInAnimation = true
                            withAnimation(.easeInOut(duration: 0)) {
                                showLoading = false
                            }
                        }

                        try? await Task.sleep(for: .seconds(0.08))
                        await MainActor.run {
                            playContentInAnimation = true
                        }

                        try? await Task.sleep(for: .seconds(1.2))
                        await MainActor.run {
                            showContentInAnimation = false
                        }
                    }
                } else {
                    // Reset when logging out
                    allowContent = false
                    showContentInAnimation = false
                    playContentInAnimation = false
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .preferredColorScheme(
                appTheme == "Dark" ? .dark :
                appTheme == "Light" ? .light :
                nil
            )
        }
    }
}

