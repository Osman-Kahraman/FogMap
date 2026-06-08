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

    @EnvironmentObject var authManager: AuthManager

    @AppStorage("appTheme") private var appTheme: String = AppTheme.system.rawValue
    @AppStorage("fogOpacity") private var fogOpacity: Double = 0.8
    @AppStorage("mapStyle") private var mapStyle: String = "Standard"
    @AppStorage("iCloudBackupEnabled") private var iCloudEnabled = false
    @AppStorage("iCloudAutoSyncEnabled") private var iCloudAutoSync = true

    @State private var lastBackupDate: Date? = nil
    @State private var backupSize: String = "0 countries"
    @State private var iCloudStatus = "Checking"
    @State private var statusMessage: String?
    @State private var isWorking = false

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
                    HStack {
                        Text("iCloud Status")
                        Spacer()
                        Text(iCloudStatus)
                            .foregroundColor(.secondary)
                    }

                    Toggle("Enable iCloud Backup", isOn: $iCloudEnabled)

                    Toggle("Auto Sync", isOn: $iCloudAutoSync)
                        .disabled(!iCloudEnabled)

                    Button("Backup Now") {
                        Task {
                            await backupNow()
                        }
                    }
                    .disabled(!canUseCloudBackup)

                    Button("Restore from iCloud") {
                        Task {
                            await restoreBackup()
                        }
                    }
                    .disabled(!canUseCloudBackup)

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

                    if let statusMessage {
                        Text(statusMessage)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }

                Section(header: Text("About")) {
                    Text("Version 0.8")
                }
            }
            .navigationTitle("Settings")
            .task {
                await refreshCloudStatus()
                await refreshBackupMetadata()
            }
        }
    }

    private var canUseCloudBackup: Bool {
        iCloudEnabled && iCloudStatus == "Available" && !isWorking
    }

    private func refreshCloudStatus() async {
        do {
            let status = try await CloudBackupService.shared.accountStatus()
            iCloudStatus = label(for: status)
        } catch {
            iCloudStatus = "Unavailable"
            statusMessage = error.localizedDescription
        }
    }

    private func refreshBackupMetadata() async {
        do {
            guard let backup = try await CloudBackupService.shared.fetchBackup() else { return }
            lastBackupDate = backup.updatedAt
            backupSize = "\(backup.visitedCountries.count) countries"
        } catch {
            statusMessage = error.localizedDescription
        }
    }

    private func backupNow() async {
        guard let uid = authManager.currentUserID else {
            statusMessage = "You need to be signed in."
            return
        }

        isWorking = true
        defer { isWorking = false }

        guard let profile = await UserService.shared.fetchUserProfile(uid: uid) else {
            statusMessage = "Could not load your profile."
            return
        }

        do {
            try await CloudBackupService.shared.saveVisitedCountries(profile.visitedCountries)
            lastBackupDate = Date()
            backupSize = "\(profile.visitedCountries.count) countries"
            statusMessage = "Backup completed."
        } catch {
            statusMessage = error.localizedDescription
        }
    }

    private func restoreBackup() async {
        guard let uid = authManager.currentUserID else {
            statusMessage = "You need to be signed in."
            return
        }

        isWorking = true
        defer { isWorking = false }

        do {
            guard let backup = try await CloudBackupService.shared.fetchBackup() else {
                statusMessage = "No iCloud backup found."
                return
            }

            let currentCountries = await UserService.shared.fetchUserProfile(uid: uid)?.visitedCountries ?? []
            let mergedCountries = Array(Set(currentCountries).union(backup.visitedCountries)).sorted()

            try await UserService.shared.updateVisitedCountries(uid: uid, countries: mergedCountries)

            lastBackupDate = backup.updatedAt
            backupSize = "\(backup.visitedCountries.count) countries"
            statusMessage = "Restore completed."
        } catch {
            statusMessage = error.localizedDescription
        }
    }

    private func label(for status: CKAccountStatus) -> String {
        switch status {
        case .available:
            return "Available"
        case .couldNotDetermine:
            return "Unknown"
        case .noAccount:
            return "No Account"
        case .restricted:
            return "Restricted"
        case .temporarilyUnavailable:
            return "Unavailable"
        @unknown default:
            return "Unknown"
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthManager())
}
