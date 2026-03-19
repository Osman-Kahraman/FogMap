//
//  LeaderboardView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//


import SwiftUI

struct LeaderboardView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Coming soon after beta testing")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Leaderboard")
        }
    }
}

#Preview {
    LeaderboardView()
}
