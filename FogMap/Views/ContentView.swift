//
//  ContentView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject var locationManager = LocationManager()
    @State private var recenterMap = false
    @AppStorage("appTheme") private var appTheme: String = "System"

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        // Unselected items (normal)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]

        // Selected items
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.label
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.label]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {

        TabView {

            MapTabView(locationManager: locationManager, recenterMap: $recenterMap)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }

            PassportView()
                .tabItem {
                    Image(systemName: "wallet.pass")
                    Text("Passport")
                }

            LeaderboardView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                    Text("Leaderboard")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .preferredColorScheme(
            appTheme == "Dark" ? .dark :
            appTheme == "Light" ? .light :
            nil
        )
    }
}

#Preview {
    ContentView()
}
