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

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {

        WindowGroup {
            Group {
                if authManager.isLoggedIn {
                    ContentView()
                        .environmentObject(authManager)
                } else {
                    LoginView()
                        .environmentObject(authManager)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
