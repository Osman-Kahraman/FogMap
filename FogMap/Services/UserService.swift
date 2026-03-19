//
//  UserService.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-18.
//

import FirebaseFirestore
import FirebaseAuth

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
    
    func createUserIfNeeded(
        uid: String,
        email: String,
        firstName: String,
        lastName: String,
        nationality: String
    ) async {
        
        let ref = db.collection("users").document(uid)

        do {
            let doc = try await ref.getDocument()

            if !doc.exists {
                try await ref.setData([
                    "email": email,
                    "firstName": firstName,
                    "lastName": lastName,
                    "nationality": nationality,
                    "visitedCountries": [],
                    "createdAt": Date()
                ])
            }
        } catch {
            print("createUserIfNeeded error:", error)
        }
    }
}
