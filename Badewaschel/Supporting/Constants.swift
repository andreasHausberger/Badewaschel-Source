//
//  Constants.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    static var spotURL = "https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:BADESTELLENOGD&srsName=EPSG:4326&outputFormat=json"
    static var poolURL = "https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:SCHWIMMBADOGD&srsName=EPSG:4326&outputFormat=json"
    
    static var warningText = """
    Das letzte Untersuchungsdatum dieser Badestelle liegt bereits länger als 30 Tage zurück. Die tatsächlichen Werte können daher von den hier angegebenen abweichen.
    """
    
    struct Map {
        static var center = CLLocationCoordinate2D(latitude: 48.20, longitude: 16.37)
        static var latMeters: CLLocationDistance = 15000
        static var lonMeters: CLLocationDistance = 15000
    }
}
