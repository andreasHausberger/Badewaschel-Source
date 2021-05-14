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
    var spot: Spot?
    
    func getName() -> String {
        return pool?.properties.name ?? spot?.properties.name ?? ""
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

}
