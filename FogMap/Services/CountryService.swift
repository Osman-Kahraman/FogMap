//
//  CountryService.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-18.
//

import Foundation
import CoreLocation

class CountryService {
    static let shared = CountryService()

    private let geocoder = CLGeocoder()
    private let polygonService = CountryPolygonService.shared

    func detectCountry(from location: CLLocation) async -> String? {

        // 1. Try geocoder
        if let country = try? await geocoder.reverseGeocodeLocation(location).first?.country {
            return country
        }

        // 2. Fallback
        return polygonService.detectCountry(for: location.coordinate)
    }
}
