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
    @AppStorage("appTheme") private var appTheme: String = "Dark"

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
                }

            PassportView()
                .tabItem {
                    Image(systemName: "wallet.pass")
                }

            LeaderboardView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
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
