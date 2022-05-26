//
//  PoolPlacemark.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 05.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import MapKit

class CustomAnnotation: MKPointAnnotation, Identifiable {
    
    var id = UUID()
    var pool: Pool?
    var spot: FederalSpot?
    
    init(pool: Pool? = nil, spot: FederalSpot? = nil) {
        self.pool = pool
        self.spot = spot
    }
    
    func getName() -> String {
        return pool?.properties.name ?? spot?.badegewaessername ?? ""
    }
    
    func getColor() -> Color {
        if let actualPool = self.pool {
            return Color.getColorForCapacity(capacity: actualPool.properties.auslastungAmpelKategorie0)
        }
        else if self.spot != nil {
            return .blue
        }
        return .gray
    }
    
    var location: CLLocationCoordinate2D {
        if let pool = pool {
            let coordinates = pool.geometry.coordinates
            return CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
        } else if let spot = spot {
            let latLon = spot.getLatLon()
            return CLLocationCoordinate2D(latitude: latLon.lat, longitude: latLon.lon)
        } else {
            return coordinate
        }
    }
}
