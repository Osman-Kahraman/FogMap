//
//  FogMapApp.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-14.
//

import SwiftUI

@main
struct FogMapApp: App {

    @StateObject var authManager = AuthManager()

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
