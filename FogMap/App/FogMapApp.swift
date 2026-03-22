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

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {

        WindowGroup {
            ZStack {
                if authManager.isLoggedIn {
                    ContentView()
                        .environmentObject(authManager)
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
            .onChange(of: authManager.isLoggedIn) {
                if authManager.isLoggedIn {
                    showLoading = true

                    Task {
                        try? await Task.sleep(nanoseconds: 7_400_000_000)

                        await MainActor.run {
                            withAnimation(.easeInOut(duration: 0)) {
                                showLoading = false
                            }
                        }
                    }
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
