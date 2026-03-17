//
//  DiscoveryView.swift
//  FoggyMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI

struct PassportView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {

        ScrollView {
            VStack(spacing: 20) {

                // Passport Card
                VStack(alignment: .leading, spacing: 16) {

                    HStack(alignment: .top, spacing: 16) {

                        // Profile Photo + Logout
                        VStack(spacing: 8) {

                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 90)
                                .foregroundColor(.gray)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            Button("Logout") {
                                authManager.isLoggedIn = false
                            }
                            .font(.caption)
                            .foregroundColor(.red)
                        }

                        VStack(alignment: .leading, spacing: 6) {

                            Text("Name")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("Osman")
                                .font(.headline)

                            Text("Surname")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("Kahraman")
                                .font(.headline)

                            Text("Nationality")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("Turkish")
                                .font(.headline)
                        }

                        Spacer()
                    }
                    
                    Divider()

                    VStack(spacing: 10) {

                        Text("Passport ID")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        HStack(spacing: 3) {
                            ForEach(0..<60) { i in
                                Rectangle()
                                    .fill(Color.primary) // black in light mode, white in dark mode
                                    .frame(width: i % 3 == 0 ? 4 : 2, height: 60)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)

                        Text("FM-2047-000392")
                            .font(.caption2)
                            .tracking(2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    Divider()

                    // Passport Stamps
                    Text("Visited Countries")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {

                        ForEach(0..<12) { _ in
                            ZStack {
                                Circle()
                                    .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                                    .frame(width: 50, height: 50)

                                Image(systemName: "globe.europe.africa.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .shadow(radius: 8)
                )
                .padding()
            }
        }
        .navigationTitle("Passport")
    }
}

#Preview {
    PassportView()
}
