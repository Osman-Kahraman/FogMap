//
//  UserService.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-18.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()

    func addVisitedCountry(_ country: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            try await db.collection("users")
                .document(uid)
                .updateData([
                    "visitedCountries": FieldValue.arrayUnion([country])
                ])
        } catch {
            print("Firestore error:", error)
        }
    }
    
    func createUserIfNeeded(_ profile: UserProfile) async {
        let ref = db.collection("users").document(profile.uid)

        do {
            let doc = try await ref.getDocument()

            if !doc.exists {
                try await ref.setData(profile.firestoreData)
            }
        } catch {
            print("createUserIfNeeded error:", error)
        }
    }

    func saveUserProfile(_ profile: UserProfile) async throws {
        try await db.collection("users")
            .document(profile.uid)
            .setData(profile.firestoreData)
    }

    func fetchUserProfile(uid: String) async -> UserProfile? {
        do {
            let doc = try await db.collection("users").document(uid).getDocument()

            guard let data = doc.data() else { return nil }

            return UserProfile(uid: uid, data: data)
        } catch {
            print("fetchUserProfile error:", error)
            return nil
        }
    }

    func updateVisitedCountries(uid: String, countries: [String]) async throws {
        try await db.collection("users")
            .document(uid)
            .setData([
                "visitedCountries": Array(Set(countries)).sorted()
            ], merge: true)
    }
}
