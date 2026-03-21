//
//  SettingsView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI
import CloudKit

struct SettingsView: View {
    enum AppTheme: String, CaseIterable, Identifiable {
        case system = "System"
        case light = "Light"
        case dark = "Dark"

        var id: String { rawValue }
    }

    @AppStorage("appTheme") private var appTheme: String = AppTheme.system.rawValue
    @AppStorage("fogOpacity") private var fogOpacity: Double = 0.8
    @AppStorage("mapStyle") private var mapStyle: String = "Standard"
    @State private var iCloudEnabled = false
    @State private var iCloudAutoSync = true
    @State private var lastBackupDate: Date? = nil
    @State private var backupSize: String = "0 MB"

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
                
                Section(header: Text("Map Settings")) {

                    Picker("Map Style", selection: $mapStyle) {
                        Text("Standard").tag("Standard")
                        Text("Satellite").tag("Satellite")
                    }

                    VStack(alignment: .leading) {
                        Text("Fog Opacity")
                        HStack {
                            Slider(value: $fogOpacity, in: 0.3...1.0)
                            Text("\(Int(fogOpacity * 100))%")
                        }
                    }
                }
                
                Section(header: Label("Cloud Backup", systemImage: "icloud")) {

                    Toggle("Enable iCloud Backup", isOn: $iCloudEnabled)

                    Toggle("Auto Sync", isOn: $iCloudAutoSync)
                        .disabled(!iCloudEnabled)

                    Button("Backup Now") {
                        Task {
                            // I should replace this with real data source later
                            let sampleCountries = ["Canada", "Turkey", "Japan"]

                            await CloudBackupService.shared.saveVisitedCountries(sampleCountries)

                            lastBackupDate = Date()
                            backupSize = "\(sampleCountries.count) countries"
                        }
                    }
                    .disabled(!iCloudEnabled)

                    Button("Restore from iCloud") {
                        print("It will be added one I pay Apple Developer account...")
                        /*Task {
                            if let countries = await CloudBackupService.shared.fetchBackup() {
                                print("Restored countries:", countries)

                                lastBackupDate = Date()
                                backupSize = "\(countries.count) countries"
                            }
                        }*/
                    }
                    .disabled(!iCloudEnabled)

                    HStack {
                        Text("Last Backup")
                        Spacer()
                        if let lastBackupDate {
                            Text(lastBackupDate, style: .relative)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Never")
                                .foregroundColor(.secondary)
                        }
                    }

                    HStack {
                        Text("Backup Size")
                        Spacer()
                        Text(backupSize)
                            .foregroundColor(.secondary)
                    }
                }
                Section(header: Text("About")) {
                    Text("Version 0.6-beta")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
