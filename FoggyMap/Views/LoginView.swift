//
//  LoginView.swift
//  FoggyMap
//
//  Created by Osman Kahraman on 2026-03-16.
//


import SwiftUI

struct LoginView: View {

    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""

    var body: some View {

        VStack(spacing: 30) {

            Spacer()

            // Logo
            VStack(spacing: 10) {

                Image(systemName: "globe.europe.africa.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)

                Text("FoggyMap")
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
                    try? await authManager.login(email: email, password: password)
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

                Button {
                    // Apple login
                } label: {

                    Label("Apple", systemImage: "applelogo")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(10)
                }

                Button {
                    // Google login
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
                    // sign up
                }
                .fontWeight(.bold)
            }

            Spacer()
        }
        .navigationTitle("Login")
    }
}

#Preview {
    LoginView()
}
