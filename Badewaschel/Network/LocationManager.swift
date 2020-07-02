//
//  LocationManager.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 02.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    private var manager = CLLocationManager()
    
    @Published var userLocation: CLLocation?
    
    @Published var locationIsAvailable = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.userLocation = manager.location
            self.locationIsAvailable = true
        }
    }
}
