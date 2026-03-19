//
//  CountryPolygonService.swift
//  FogMap
//
//  Created by Osman Kahraman on 2026-03-18.
//

import Foundation
import CoreLocation

struct Country {
    let name: String
    let polygons: [[CLLocationCoordinate2D]]
}

class CountryPolygonService {

    static let shared = CountryPolygonService()

    private(set) var countries: [Country] = []

    private init() {
        loadCountries()
    }

    private func loadCountries() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "geojson"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let features = json["features"] as? [[String: Any]] else {
            print("Failed to load countries.geojson")
            return
        }

        var parsed: [Country] = []

        for feature in features {
            let properties = feature["properties"] as? [String: Any]
            let name = properties?["name"] as? String ?? "Unknown"

            guard let geometry = feature["geometry"] as? [String: Any],
                  let type = geometry["type"] as? String else { continue }

            var polygons: [[CLLocationCoordinate2D]] = []

            if type == "Polygon",
               let coords = geometry["coordinates"] as? [[[Double]]] {

                let polygon = coords[0].map {
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                }

                polygons.append(polygon)
            }

            if type == "MultiPolygon",
               let coords = geometry["coordinates"] as? [[[[Double]]]] {

                for poly in coords {
                    let polygon = poly[0].map {
                        CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                    }
                    polygons.append(polygon)
                }
            }

            parsed.append(Country(name: name, polygons: polygons))
        }

        countries = parsed
    }

    func detectCountry(for location: CLLocationCoordinate2D) -> String? {
        for country in countries {
            for polygon in country.polygons {
                if isPointInsidePolygon(point: location, polygon: polygon) {
                    return country.name
                }
            }
        }
        return nil
    }

    private func isPointInsidePolygon(point: CLLocationCoordinate2D,
                                     polygon: [CLLocationCoordinate2D]) -> Bool {
        var inside = false
        var j = polygon.count - 1

        for i in 0..<polygon.count {
            let xi = polygon[i].latitude
            let yi = polygon[i].longitude
            let xj = polygon[j].latitude
            let yj = polygon[j].longitude

            let intersect = ((yi > point.longitude) != (yj > point.longitude)) &&
            (point.latitude < (xj - xi) * (point.longitude - yi) / (yj - yi + 0.0000001) + xi)

            if intersect {
                inside.toggle()
            }

            j = i
        }

        return inside
    }
}
