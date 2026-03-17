//
//  SignupView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-17.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import PhotosUI

struct SignupView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var nationality = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    private var countries: [(code: String, name: String)] {
        Locale.Region.isoRegions
            .filter { $0.identifier.count == 2 } // only real ISO country codes
            .compactMap { region in
                guard let name = Locale.current.localizedString(forRegionCode: region.identifier) else { return nil }
                return (code: region.identifier, name: name)
            }
            .sorted { $0.name < $1.name }
    }

    var body: some View {

        VStack(spacing: 25) {
            Spacer()

            VStack(spacing: 22) {
                VStack(alignment: .leading, spacing: 10) {

                    Text("Name")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 6)

                    VStack(spacing: 12) {

                        TextField("First Name", text: $firstName)
                            .textInputAutocapitalization(.words)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)

                        TextField("Last Name", text: $lastName)
                            .textInputAutocapitalization(.words)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Nationality")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 6)

                    Picker(selection: $nationality) {
                        Text("Select Nationality").tag("")
                        ForEach(countries, id: \.code) { country in
                            let flag = country.code
                                .uppercased()
                                .unicodeScalars
                                .compactMap { UnicodeScalar(127397 + $0.value) }
                                .map { String($0) }
                                .joined()

                            Text("\(flag) \(country.name)")
                                .tag(country.name)
                        }
                    } label: {
                        Text(nationality.isEmpty ? "Select Nationality" : nationality)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .pickerStyle(.menu)
                    .tint(.gray)
                    .frame(maxWidth: 300)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }

                VStack(alignment: .leading, spacing: 10) {

                    Text("Account")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 6)

                    VStack(spacing: 12) {

                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)

                        SecureField("Password", text: $password)
                            .textContentType(.newPassword)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)

            Button {
                guard password == confirmPassword else { return }

                Task {
                    do {
                        try await authManager.createAccount(email: email, password: password)

                        guard let uid = Auth.auth().currentUser?.uid else { return }

                        let db = Firestore.firestore()

                        let photoURL: String = ""

                        try await db.collection("users").document(uid).setData([
                            "firstName": firstName,
                            "lastName": lastName,
                            "nationality": nationality,
                            "email": email,
                            "photoURL": photoURL,
                            "createdAt": Timestamp(date: Date())
                        ])

                        print("User created and profile saved")

                    } catch {
                        print("Signup error:", error.localizedDescription)
                    }
                }

            } label: {
                Text("Create")
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
        .navigationTitle("Create Account")
    }
}

#Preview {
    SignupView()
}
