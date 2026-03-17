//
//  AuthManager.swift
//  FoggyMap
//
//  Created by Osman Kahraman on 2026-03-16.
//


import Foundation

class AuthManager: ObservableObject {

    @Published var isLoggedIn = false

    func login(email: String, password: String) async throws {

        // burada backend API çağrısı olacak

        let url = URL(string: "https://api.fogmap.com/login")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let body = [
            "email": email,
            "password": password
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        if httpResponse.statusCode == 200 {
            DispatchQueue.main.async {
                self.isLoggedIn = true
            }
        } else {
            throw URLError(.userAuthenticationRequired)
        }
    }
}
