//
//  FogMapApp.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-14.
//

import SwiftUI
import FirebaseCore

@main
struct FogMapApp: App {
    @StateObject var authManager = AuthManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {

        WindowGroup {

            if authManager.isLoggedIn {
                ContentView()
                    .environmentObject(authManager)
            } else {
                LoginView()
                    .environmentObject(authManager)
            }
        }
    }
}
