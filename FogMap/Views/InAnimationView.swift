//
//  InAnimationView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-22.
//

import SwiftUI

struct InAnimationView: View {

    @State private var animate = false
    @State private var expand = false
    
    var body: some View {
        
        ZStack {

            Color.black.ignoresSafeArea()

            // Fog
            Circle()
                .fill(Color.black)
                .frame(width: expand ? 1200 : 0, height: expand ? 1200 : 0)
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
    InAnimationView()
}
