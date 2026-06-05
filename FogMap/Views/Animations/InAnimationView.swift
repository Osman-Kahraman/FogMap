//
//  InAnimationView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-22.
//

import SwiftUI

struct InAnimationView: View {
    let play: Bool

    @State private var expand = false

    init(play: Bool = true) {
        self.play = play
    }

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
                            .frame(
                                width: expand ? diagonal * 2 : 0,
                                height: expand ? diagonal * 2 : 0
                            )
                            .position(
                                x: geo.size.width / 2,
                                y: geo.size.height / 2
                            )
                            .blendMode(.destinationOut)
                    }
                    .compositingGroup()
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .onAppear {
            expand = false
            animateIfNeeded()
        }
        .onChange(of: play) {
            animateIfNeeded()
        }
    }

    private func animateIfNeeded() {
        guard play else { return }

        withAnimation(.easeInOut(duration: 1.2)) {
            expand = true
        }
    }
}

#Preview {
    InAnimationView()
}
