//
//  DiscoveryView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PassportView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.colorScheme) var colorScheme
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var nationality: String = ""
    @State private var visitedCountries: [String] = []
    @State private var newlyUnlocked: Set<String> = []
    @State private var showLoading = false
    
    init(
        firstName: String = "",
        lastName: String = "",
        nationality: String = "",
        visitedCountries: [String] = []
    ) {
        _firstName = State(initialValue: firstName)
        _lastName = State(initialValue: lastName)
        _nationality = State(initialValue: nationality)
        _visitedCountries = State(initialValue: visitedCountries)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Passport Card
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack(alignment: .top, spacing: 16) {
                            
                            // Profile Photo + Logout
                            VStack(spacing: 8) {
                                Image("pp_default")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 140, height: 140)
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Button("Logout") {
                                    showLoading = true

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        do {
                                            try authManager.logout()
                                        } catch {
                                            print("Logout failed:", error)
                                            showLoading = false
                                        }
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text("Name")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(firstName.isEmpty ? "—" : firstName)
                                    .font(.headline)
                                
                                Text("Surname")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(lastName.isEmpty ? "—" : lastName)
                                    .font(.headline)
                                
                                Text("Nationality")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text(nationality.isEmpty ? "—" : nationality)
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

                        // Exploration Stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Stats")
                                .font(.headline)
                            
                            VStack {
                                HStack {
                                    Text("Countries Visited")
                                    Spacer()
                                    Text("\(visitedCountries.count)")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.secondary)
                                }

                                HStack {
                                    Text("Explored")
                                    Spacer()
                                    Text(String(format: "%.5f%%", MapViewRepresentable.exploredPercentage()))
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(20)
                        }

                        Divider()

                        // Passport Stamps
                        Text("Stamps")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            
                            ForEach(visitedCountries, id: \.self) { country in
                                let isNew = newlyUnlocked.contains(country)
                                
                                VStack(spacing: 6) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 2)
                                            .frame(width: 120, height: 80)
                                        
                                        VStack {
                                            Text(country)
                                                .font(.caption)
                                                .foregroundColor(.primary)
                                            
                                            Text(flagEmoji(for: country))
                                                .font(.system(size: 55))
                                        }
                                        
                                        HStack {
                                            Spacer()
                                            VStack {
                                                Spacer()
                                                
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 35))
                                                    .foregroundColor(.green)
                                                    .padding(4)
                                                    .scaleEffect(isNew ? 2 : 1)
                                                    .opacity(isNew ? 1 : 0.8)
                                                    .animation(.spring(), value: isNew)
                                                    .background(
                                                        Circle()
                                                            .fill(colorScheme == .dark ? Color.black : Color.white)
                                                            .stroke(.green)
                                                    )
                                            }
                                        }
                                    }
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
                }.navigationTitle("Passport")
            }
        }
        .overlay {
            if showLoading {
                OutAnimationView()
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
        .navigationTitle("Passport")
        .task {
            guard let uid = Auth.auth().currentUser?.uid else { return }

            let db = Firestore.firestore()
            let doc = try? await db.collection("users").document(uid).getDocument()

            if let data = doc?.data() {
                firstName = data["firstName"] as? String ?? ""
                lastName = data["lastName"] as? String ?? ""
                nationality = data["nationality"] as? String ?? ""
                
                let newCountries = data["visitedCountries"] as? [String] ?? []

                // Preventing first load of visitedCountries can be empty
                if visitedCountries.isEmpty {
                    visitedCountries = newCountries
                } else {
                    let diff = Set(newCountries).subtracting(visitedCountries)
                    visitedCountries = newCountries
                    newlyUnlocked = diff

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        newlyUnlocked.removeAll()
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    newlyUnlocked.removeAll()
                }
            }
        }
    }
    
    func flagEmoji(for country: String) -> String {
        let locale = Locale.current

        guard let region = Locale.Region.isoRegions.first(where: {
            locale.localizedString(forRegionCode: $0.identifier) == country
        }) else {
            return "🌍"
        }

        let code = region.identifier

        return code
            .uppercased()
            .unicodeScalars
            .compactMap { UnicodeScalar(127397 + $0.value) }
            .map { String($0) }
            .joined()
    }
}

#Preview {
    PassportView(firstName: "Osman", lastName: "Kahraman", nationality: "Turkish", visitedCountries: ["United States", "Türkiye", "Japan", "Germany"])
}
