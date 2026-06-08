//
//  CloudBackupService.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-19.
//

import CloudKit
import Foundation

struct CloudMapBackup {
    let visitedCountries: [String]
    let updatedAt: Date?
}

final class CloudBackupService {
    static let shared = CloudBackupService()

    private let container = CKContainer(identifier: "iCloud.kahramanosman.FogMap")
    private let recordID = CKRecord.ID(recordName: "user-map-backup")

    private var db: CKDatabase {
        container.privateCloudDatabase
    }

    func accountStatus() async throws -> CKAccountStatus {
        try await container.accountStatus()
    }

    func saveVisitedCountries(_ countries: [String]) async throws {
        let record = try await existingBackupRecord()
        let sortedCountries = Array(Set(countries)).sorted()

        record["visitedCountries"] = sortedCountries as CKRecordValue
        record["updatedAt"] = Date() as CKRecordValue

        _ = try await db.save(record)
    }

    func fetchBackup() async throws -> CloudMapBackup? {
        do {
            let record = try await db.record(for: recordID)
            let countries = record["visitedCountries"] as? [String] ?? []
            let updatedAt = record["updatedAt"] as? Date
            return CloudMapBackup(visitedCountries: countries, updatedAt: updatedAt)
        } catch {
            if isMissingRecord(error) {
                return nil
            }

            throw error
        }
    }

    private func existingBackupRecord() async throws -> CKRecord {
        do {
            return try await db.record(for: recordID)
        } catch {
            if isMissingRecord(error) {
                return CKRecord(recordType: "MapBackup", recordID: recordID)
            }

            throw error
        }
    }

    private func isMissingRecord(_ error: Error) -> Bool {
        guard let ckError = error as? CKError else { return false }
        return ckError.code == .unknownItem
    }
}
