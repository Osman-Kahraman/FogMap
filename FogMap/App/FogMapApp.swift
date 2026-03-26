//
//  FogMapApp.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-14.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct FogMapApp: App {
    @StateObject var authManager = AuthManager()
    @AppStorage("appTheme") private var appTheme: String = "Dark"
    @State private var showLoading = false
    @State private var allowContent = false

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
            }
            .onChange(of: authManager.isLoggedIn) { oldValue, newValue in
                if newValue {
                    showLoading = true
                    allowContent = false

                    Task {
                        try? await Task.sleep(nanoseconds: 7_400_000_000)

                        await MainActor.run {
                            allowContent = true
                            withAnimation(.easeInOut(duration: 0)) {
                                showLoading = false
                            }
                        }
                    }
                } else {
                    // Reset when logging out
                    allowContent = false
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
