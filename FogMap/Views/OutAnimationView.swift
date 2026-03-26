//
//  OutAnimationView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-22.
//

import SwiftUI

struct OutAnimationView: View {

    @State private var animate = false
    @State private var expand = false
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
        }
        .mask(
            ZStack {
                Rectangle()
                    .fill(Color.white)

                Circle()
                    .frame(width: 1200, height: 1200)
                    .scaleEffect(expand ? 0.01 : 1)
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
    OutAnimationView()
}
