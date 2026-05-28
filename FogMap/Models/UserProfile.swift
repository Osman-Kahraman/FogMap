//
//  UserProfile.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-19.
//

import Foundation
import FirebaseFirestore

struct UserProfile {
    let uid: String
    let email: String
    let firstName: String
    let lastName: String
    let nationality: String
    let photoURL: String
    let visitedCountries: [String]
    let createdAt: Date

    init(
        uid: String,
        email: String,
        firstName: String,
        lastName: String,
        nationality: String,
        photoURL: String = "",
        visitedCountries: [String] = [],
        createdAt: Date = Date()
    ) {
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.nationality = nationality
        self.photoURL = photoURL
        self.visitedCountries = visitedCountries
        self.createdAt = createdAt
    }

    init(uid: String, data: [String: Any]) {
        self.uid = uid
        self.email = data["email"] as? String ?? ""
        self.firstName = data["firstName"] as? String ?? ""
        self.lastName = data["lastName"] as? String ?? ""
        self.nationality = data["nationality"] as? String ?? ""
        self.photoURL = data["photoURL"] as? String ?? ""
        self.visitedCountries = data["visitedCountries"] as? [String] ?? []

        if let date = data["createdAt"] as? Date {
            self.createdAt = date
        } else if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }

    var firestoreData: [String: Any] {
        [
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "nationality": nationality,
            "photoURL": photoURL,
            "visitedCountries": visitedCountries,
            "createdAt": createdAt
        ]
    }
}
