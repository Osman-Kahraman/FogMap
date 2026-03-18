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
    private var visitedCountries: Set<String> = []
    private let db = Firestore.firestore()

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
            if let country = await countryDetector.getCountry(from: newLocation) {
                // Avoid duplicates
                if !visitedCountries.contains(country) {
                    visitedCountries.insert(country)

                    // Sync with Firestore
                    await saveVisitedCountries()
                }
            }
        }
    }
    
    @MainActor
    func saveVisitedCountries() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        do {
            try await db.collection("users")
                .document(uid)
                .setData([
                    "visitedCountries": Array(visitedCountries)
                ], merge: true)
        } catch {
            print("Firestore save error:", error)
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
