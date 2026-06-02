//
//  PassportViewModel.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-05-27.
//

import Foundation

protocol UserProfileProviding {
    func fetchUserProfile(uid: String) async -> UserProfile?
}

extension UserService: UserProfileProviding { }

@MainActor
final class PassportViewModel: ObservableObject {
    @Published private(set) var firstName: String
    @Published private(set) var lastName: String
    @Published private(set) var nationality: String
    @Published private(set) var visitedCountries: [String]
    @Published private(set) var newlyUnlocked: Set<String> = []

    private let userService: UserProfileProviding

    init(
        firstName: String = "",
        lastName: String = "",
        nationality: String = "",
        visitedCountries: [String] = [],
        userService: UserProfileProviding = UserService.shared
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.nationality = nationality
        self.visitedCountries = visitedCountries
        self.userService = userService
    }

    func loadProfile(uid: String?) async {
        guard let uid else { return }
        guard let profile = await userService.fetchUserProfile(uid: uid) else { return }

        firstName = profile.firstName
        lastName = profile.lastName
        nationality = profile.nationality

        let newCountries = profile.visitedCountries

        if visitedCountries.isEmpty {
            visitedCountries = newCountries
        } else {
            let diff = Set(newCountries).subtracting(visitedCountries)
            visitedCountries = newCountries
            newlyUnlocked = diff
        }

        clearNewlyUnlockedAfterDelay()
    }

    private func clearNewlyUnlockedAfterDelay() {
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(2))
            self?.newlyUnlocked.removeAll()
        }
    }
}
