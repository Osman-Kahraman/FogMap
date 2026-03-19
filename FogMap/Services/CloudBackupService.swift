//
//  CloudBackupService.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-19.
//


import CloudKit

class CloudBackupService {

    static let shared = CloudBackupService()
    private let db = CKContainer.default().privateCloudDatabase

    func saveVisitedCountries(_ countries: [String]) async {
        let recordID = CKRecord.ID(recordName: "user-map-backup")
        let record = CKRecord(recordType: "MapBackup", recordID: recordID)

        record["visitedCountries"] = countries as CKRecordValue
        record["updatedAt"] = Date() as CKRecordValue

        do {
            try await db.save(record)
            print("Map backup saved (updated)")
        } catch {
            print("iCloud save error:", error)
        }
    }

    func fetchBackup() async -> [String]? {
        let recordID = CKRecord.ID(recordName: "user-map-backup")

        do {
            let record = try await db.record(for: recordID)
            return record["visitedCountries"] as? [String]
        } catch {
            print("iCloud fetch error:", error)
            return nil
        }
    }
}
