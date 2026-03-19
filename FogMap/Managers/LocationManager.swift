//
//  LocationManager.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-14.
//

import CoreLocation
import FirebaseAuth
import FirebaseFirestore

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var lastProcessedLocation: CLLocation?
    var onSignificantLocationUpdate: ((CLLocation) -> Void)?
    private let distanceThreshold: CLLocationDistance = 500
    private let countryDetector = CountryDetector()
    private let polygonService = CountryPolygonService.shared
    private var visitedCountries: Set<String> = []
    private let db = Firestore.firestore()
    private var lastCloudSync: Date = .distantPast

    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let newLocation = locations.last else { return }
        location = newLocation

        if let last = lastProcessedLocation {
            let distance = last.distance(from: newLocation)
            if distance < distanceThreshold {
                return
            }
        }

        // Update last processed location
        lastProcessedLocation = newLocation

        // Trigger hook (for country detection, etc.)
        onSignificantLocationUpdate?(newLocation)

        // Detect country (async)
        Task {
            if let country = await CountryService.shared.detectCountry(from: newLocation) {
                await UserService.shared.addVisitedCountry(country)
                visitedCountries.insert(country)

                // Throttled iCloud backup (every 30s)
                let now = Date()
                if now.timeIntervalSince(lastCloudSync) > 30 {
                    lastCloudSync = now
                    await CloudBackupService.shared.saveVisitedCountries(
                        Array(visitedCountries)
                    )
                }
            }
        }
    }
}

class CountryDetector {
    private let geocoder = CLGeocoder()

    func getCountry(from location: CLLocation) async -> String? {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            return placemarks.first?.country
        } catch {
            print("Geocoding failed:", error)
            return nil
        }
    }
}
