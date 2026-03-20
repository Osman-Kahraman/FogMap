//
//  ContentView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var locationManager = LocationManager()
    @State private var recenterMap = false
    @State private var selectedTab: Int = 0
    @AppStorage("appTheme") private var appTheme: String = "Dark"

    func updateTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        if appTheme == "Dark" {
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        } else {
            appearance.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        }

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

        TabView(selection: $selectedTab) {

            MapTabView(locationManager: locationManager, recenterMap: $recenterMap)
                .tabItem {
                    Image(systemName: "map.fill")
                }
                .tag(0)

            PassportView()
                .tabItem {
                    Image(systemName: "wallet.pass")
                }
                .tag(1)

            LeaderboardView()
                .tabItem {
                    Image(systemName: "trophy.fill")
                }
                .tag(2)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
                .tag(3)
        }
        .id(appTheme)
        .onAppear {
            updateTabBarAppearance()
        }
        .onChange(of: appTheme) {
            updateTabBarAppearance()
        }
    }
}

#Preview {
    ContentView()
}
