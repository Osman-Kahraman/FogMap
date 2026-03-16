//
//  SettingsView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI

struct SettingsView: View {

    enum AppTheme: String, CaseIterable, Identifiable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"

        var id: String { rawValue }
    }

    @AppStorage("appTheme") private var appTheme: String = AppTheme.system.rawValue
    @State private var iCloudEnabled = false
    @State private var iCloudAutoSync = true

    var body: some View {

        NavigationStack {
            Form {
                Section(header: Text("App Preferences")) {

                    Picker("App Theme", selection: $appTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.rawValue).tag(theme.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Cloud Backup")) {

                    Toggle("Enable iCloud Backup", isOn: $iCloudEnabled)

                    Toggle("Auto Sync", isOn: $iCloudAutoSync)
                        .disabled(!iCloudEnabled)

                    Button("Backup Now") {
                        // future icloud backup
                    }
                    .disabled(!iCloudEnabled)

                    HStack {
                        Text("Last Backup")
                        Spacer()
                        Text("Never")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
