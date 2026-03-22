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

            // Fog
            Circle()
                .fill(Color.black)
                .frame(width: expand ? 0 : 1200, height: expand ? 0 : 1200)
                .blendMode(.destinationOut)
                .animation(
                    .easeInOut(duration: 1.2),
                    value: expand
                )
        }
        .compositingGroup()
        .onAppear {
            animate = true
            expand = true
        }
    }
}

#Preview {
    OutAnimationView()
}
