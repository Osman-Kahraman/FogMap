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
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = distanceThreshold
        manager.activityType = .otherNavigation
        manager.pausesLocationUpdatesAutomatically = true
        manager.showsBackgroundLocationIndicator = true

        requestAuthorizationIfNeeded()
        startEfficientLocationUpdatesIfAllowed()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        startEfficientLocationUpdatesIfAllowed()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let newLocation = locations.last else { return }
        processLocation(newLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed:", error)
    }

    private func requestAuthorizationIfNeeded() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
        default:
            break
        }
    }

    private func startEfficientLocationUpdatesIfAllowed() {
        guard CLLocationManager.locationServicesEnabled() else { return }

        switch manager.authorizationStatus {
        case .authorizedAlways:
            manager.allowsBackgroundLocationUpdates = true
            manager.startMonitoringSignificantLocationChanges()
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.allowsBackgroundLocationUpdates = true
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }

    private func processLocation(_ newLocation: CLLocation) {
        location = newLocation

        if let last = lastProcessedLocation {
            let distance = last.distance(from: newLocation)
            if distance < distanceThreshold {
                return
            }
        }

        lastProcessedLocation = newLocation
        onSignificantLocationUpdate?(newLocation)

        Task {
            if let country = await CountryService.shared.detectCountry(from: newLocation) {
                await UserService.shared.addVisitedCountry(country)
                visitedCountries.insert(country)
                await syncToICloudIfNeeded()
            }
        }
    }

    private func syncToICloudIfNeeded() async {
        let now = Date()
        let iCloudEnabled = UserDefaults.standard.bool(forKey: "iCloudBackupEnabled")
        let autoSyncEnabled = UserDefaults.standard.object(forKey: "iCloudAutoSyncEnabled") as? Bool ?? true

        guard iCloudEnabled,
              autoSyncEnabled,
              now.timeIntervalSince(lastCloudSync) > 30
        else {
            return
        }

        lastCloudSync = now

        if let uid = Auth.auth().currentUser?.uid,
           let profile = await UserService.shared.fetchUserProfile(uid: uid) {
            try? await CloudBackupService.shared.saveVisitedCountries(profile.visitedCountries)
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
