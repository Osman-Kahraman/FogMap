//
//  OutAnimationView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-22.
//

import SwiftUI

struct OutAnimationView: View {
    @State private var expand = false

    var body: some View {
        GeometryReader { geo in
            let diagonal = sqrt(
                pow(geo.size.width, 2) +
                pow(geo.size.height, 2)
            )

            Color.black
                .frame(width: geo.size.width, height: geo.size.height)
                .mask(
                    ZStack {
                        Rectangle()
                            .fill(Color.white)

                        Circle()
                            .frame(width: diagonal * 2, height: diagonal * 2)
                            .position(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                            .scaleEffect(expand ? 0 : 1)
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
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
