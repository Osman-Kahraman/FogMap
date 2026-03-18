//
//  LoginView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var showSignup = false
    @State private var currentNonce: String?
    @State private var showError = false
    @State private var errorMessage = ""

var body: some View {

    NavigationStack {

        VStack(spacing: 30) {

            Spacer()

            // Logo
            VStack(spacing: 10) {

                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("FogMap")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Explore the world")
                    .foregroundColor(.secondary)
            }

            // Inputs
            VStack(spacing: 16) {

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)

                SecureField("Password", text: $password)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Button {

                Task {
                    do {
                        try await authManager.login(email: email, password: password)
                    } catch {
                        errorMessage = "Invalid email or password. Please try again."
                        showError = true
                    }
                }

            } label: {
                Text("Login")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // Divider
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))

                Text("OR")

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .padding(.horizontal)

            // Social login
            HStack(spacing: 20) {

                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in

                        let nonce = authManager.randomNonceString()
                        currentNonce = nonce

                        request.requestedScopes = [.fullName, .email]
                        request.nonce = authManager.sha256(nonce)
                    },
                    onCompletion: { result in

                        switch result {

                        case .success(let authResults):

                            guard let appleIDCredential =
                                authResults.credential as? ASAuthorizationAppleIDCredential else { return }

                            guard let nonce = currentNonce else { return }

                            Task {
                                try? await authManager.signInWithApple(
                                    credential: appleIDCredential,
                                    nonce: nonce
                                )
                            }

                        case .failure(let error):
                            print(error)
                        }
                    }
                )
                .frame(height: 50)
                .signInWithAppleButtonStyle(.white)

                Button {
                    Task {
                        do {
                            try await authManager.signInWithGoogle()
                            print("Google login success")
                        } catch {
                            print("Google login error:", error)
                        }
                    }
                } label: {

                    HStack(spacing: 8) {
                        Image("google_favicon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)

                        Text("Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            Spacer()

            // Sign up
            HStack {
                Text("Don't have an account?")
                Button("Sign Up") {
                    showSignup = true
                }
                .fontWeight(.bold)
            }
            .sheet(isPresented: $showSignup) {
                NavigationStack {
                    SignupView()
                }
            }

            Spacer()
        }
        .alert("Login Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
