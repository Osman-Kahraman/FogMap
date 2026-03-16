//
//  MapTabView.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-16.
//


import SwiftUI
import MapKit

struct MapTabView: View {

    @ObservedObject var locationManager: LocationManager
    @Binding var recenterMap: Bool

    var body: some View {

        ZStack {

            MapViewRepresentable(locationManager: locationManager, recenter: $recenterMap)
                .ignoresSafeArea()

            VStack {
                HStack {

                    HStack(alignment: .lastTextBaseline, spacing: 8) {
                        Text("Explored")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)

                        Text(String(format: "%.5f%%", MapViewRepresentable.exploredPercentage()))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.25), lineWidth: 1)
                            )
                    )

                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 20)

                Spacer()
            }

            VStack {
                Spacer()

                HStack {
                    Spacer()

                    Button {
                        recenterMap = true
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .padding(14)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    MapTabView(
        locationManager: LocationManager(),
        recenterMap: .constant(false)
    )
}
