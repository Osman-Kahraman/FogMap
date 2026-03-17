//
//  AuthManager.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//


import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {

    private var authStateListener: AuthStateDidChangeListenerHandle?

    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil

    init() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
            }
        }
    }

    func login(email: String, password: String) async throws {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)

        DispatchQueue.main.async {
            self.isLoggedIn = result.user != nil
        }
    }
    
    func createAccount(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)

        DispatchQueue.main.async {
            self.isLoggedIn = result.user != nil
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
        DispatchQueue.main.async {
            self.isLoggedIn = false
        }
    }
}
