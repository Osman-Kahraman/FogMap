//
//  AuthManager.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//


import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

class AuthManager: ObservableObject {

    private var authStateListener: AuthStateDidChangeListenerHandle?

    @Published var isLoggedIn: Bool = Auth.auth().currentUser != nil

    init() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = (user != nil)
            }
        }
    }

    func login(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)

        DispatchQueue.main.async {
            self.isLoggedIn = true
        }
    }
    
    func createAccount(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)

        DispatchQueue.main.async {
            self.isLoggedIn = true
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
        DispatchQueue.main.async {
            self.isLoggedIn = false
        }
    }
    
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "GoogleSignIn", code: -1)
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        let rootVC = await MainActor.run { () -> UIViewController? in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return nil
            }
            return windowScene.windows.first?.rootViewController
        }

        guard let rootVC else { return }

        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)

        guard let idToken = result.user.idToken?.tokenString else { return }

        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )

        let authResult = try await Auth.auth().signIn(with: credential)

        DispatchQueue.main.async {
            self.isLoggedIn = true
        }
    }
}
