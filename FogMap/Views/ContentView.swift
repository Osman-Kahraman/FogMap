import SwiftUI
import MapKit

struct ContentView: View {

    @StateObject var locationManager = LocationManager()
    @State private var recenterMap = false

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        // Unselected items (normal)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        // Selected items
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

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

            DiscoveryView()
                .tabItem {
                    Image(systemName: "wallet.pass")
                    Text("Passport")
                }

            LeaderboardView()
                .tabItem {
                    Image(systemName: "record.circle.fill")
                    Text("Leaderboard")
                }

            CloudView()
                .tabItem {
                    Image(systemName: "cloud.fill")
                    Text("Cloud")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
}
