//
//  SettingsView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI

struct SettingsView: View {
    @State private var iCloudEnabled = false
    @State private var iCloudAutoSync = true

    var body: some View {

        NavigationStack {
            Form {
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
            .navigationTitle("Cloud Backup")
        }
    }
}

#Preview {
    SettingsView()
}
