//
//  InAnimationView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-22.
//

import SwiftUI

import SwiftUI

struct InAnimationView: View {

    @State private var expand = false
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
        }
        .mask(
            ZStack {
                Rectangle()
                    .fill(Color.white)

                // Reveal circle
                Circle()
                    .frame(width: 1200, height: 1200)
                    .scaleEffect(expand ? 1 : 0.01)
                    .blendMode(.destinationOut)
            }
            .compositingGroup()
        )
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                expand = true
            }
        }
    }
}

#Preview {
    InAnimationView()
}
