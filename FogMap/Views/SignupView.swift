//
//  SignupView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-17.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    var body: some View {

        VStack(spacing: 25) {

            Spacer()

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)

            VStack(spacing: 16) {

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)

                SecureField("Password", text: $password)
                    .textContentType(.newPassword)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)

                SecureField("Confirm Password", text: $confirmPassword)
                    .textContentType(.newPassword)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Button {

                guard password == confirmPassword else { return }

                Task {
                    do {
                        try await authManager.createAccount(email: email, password: password)
                        print("User created successfully")
                    } catch {
                        print("Signup error:", error.localizedDescription)
                    }
                }

            } label: {

                Text("Create Account")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Sign Up")
    }
}

#Preview {
    SignupView()
}
