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
                
                Section(header: Label("Cloud Backup", systemImage: "icloud")) {

                    Toggle("Enable iCloud Backup", isOn: $iCloudEnabled)

                    Toggle("Auto Sync", isOn: $iCloudAutoSync)
                        .disabled(!iCloudEnabled)

                    Button("Backup Now") {
                        Task {
                            // You should replace this with real data source later
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
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
