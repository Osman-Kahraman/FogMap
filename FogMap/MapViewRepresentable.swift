//
//  MapViewRepresentable.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-14.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

    @ObservedObject var locationManager: LocationManager
    @Binding var recenter: Bool
    static var exploredCoordinates: [CLLocationCoordinate2D] = []
    static var lastRecordedLocation: CLLocation?

    static let storageKey = "explored_coordinates"

    static func saveExplored() {
        let array = exploredCoordinates.map { ["lat": $0.latitude, "lon": $0.longitude] }
        UserDefaults.standard.set(array, forKey: storageKey)
    }

    static func loadExplored() {
        guard let saved = UserDefaults.standard.array(forKey: storageKey) as? [[String: Double]] else { return }

        exploredCoordinates = saved.compactMap {
            guard let lat = $0["lat"], let lon = $0["lon"] else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }

    func makeUIView(context: Context) -> MKMapView {

        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.2557, longitude: -79.8711),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )

        mapView.setRegion(region, animated: false)

        // load saved explored areas from disk
        Self.loadExplored()

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {

        guard let location = locationManager.location else { return }

        let coordinate = location.coordinate

        // recenter map when button pressed
        if recenter {
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )

            mapView.setRegion(region, animated: true)

            DispatchQueue.main.async {
                recenter = false
            }
        }

        // record explored areas every ~100 meters
        if let last = Self.lastRecordedLocation {
            let distance = last.distance(from: location)
            if distance > 100 {
                Self.exploredCoordinates.append(coordinate)
                Self.lastRecordedLocation = location
                Self.saveExplored()
            }
        } else {
            Self.exploredCoordinates.append(coordinate)
            Self.lastRecordedLocation = location
            Self.saveExplored()
        }

        // Center the map only once at startup
        if !context.coordinator.hasCentered {
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )

            mapView.setRegion(region, animated: false)
            context.coordinator.hasCentered = true
        }

        // remove old overlays
        mapView.removeOverlays(mapView.overlays)

        // add ONE global fog overlay that knows all explored areas
        let fog = GlobalFogOverlay(explored: Self.exploredCoordinates, radius: 500)
        mapView.addOverlay(fog, level: .aboveLabels)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        var hasCentered = false

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let fog = overlay as? GlobalFogOverlay {
                return GlobalFogRenderer(overlay: fog)
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

class GlobalFogOverlay: NSObject, MKOverlay {

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var boundingMapRect: MKMapRect = MKMapRect.world

    var explored: [CLLocationCoordinate2D]
    var radius: CLLocationDistance

    init(explored: [CLLocationCoordinate2D], radius: CLLocationDistance) {
        self.explored = explored
        self.radius = radius
    }
}

class GlobalFogRenderer: MKOverlayRenderer {
    
    let maskImage = UIImage(named: "world_land_mask")?.cgImage

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {

        guard let overlay = overlay as? GlobalFogOverlay else { return }

        let rect = self.rect(for: mapRect)
        let worldRect = self.rect(for: overlay.boundingMapRect)

        
        // fill entire map with black fog
        context.setFillColor(UIColor.black.cgColor)
        context.fill(rect)

        // Apply the land mask aligned to the entire world and flip vertically
        if let mask = maskImage {

            context.saveGState()

            // Flip only vertically
            context.translateBy(x: worldRect.minX, y: worldRect.maxY)
            context.scaleBy(x: 1, y: -1)

            let flippedRect = CGRect(x: 0, y: 0, width: worldRect.width, height: worldRect.height)

            context.setBlendMode(.destinationIn)
            context.draw(mask, in: flippedRect)
            context.setBlendMode(.normal)

            context.restoreGState()
        }

        context.setBlendMode(.clear)

        for coord in overlay.explored {

            let centerPoint = point(for: MKMapPoint(coord))

            let metersPerPoint = MKMetersPerMapPointAtLatitude(coord.latitude)
            let radius = overlay.radius / metersPerPoint

            context.addArc(
                center: centerPoint,
                radius: radius,
                startAngle: 0,
                endAngle: .pi * 2,
                clockwise: false
            )
            context.fillPath()
        }

        context.setBlendMode(.normal)
    }
}
