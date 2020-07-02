//
//  MapView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 28.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var latitude: Double
    var longitude: Double
    var name: String
    var allLocations: [MKPointAnnotation]?
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: spanConstant, longitudeDelta: spanConstant)
  
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        if let locations = allLocations {
            for location in locations {
                uiView.addAnnotation(location)
            }
        }
        else {
            let placemark = MKPointAnnotation()
            placemark.coordinate = coordinate
            placemark.title = name
            uiView.addAnnotation(placemark)
        }
        uiView.setRegion(region, animated: true)
        
    }
    
    var spanConstant: Double = 0.0025
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: 48.20, longitude: 16.37, name: "PreviewName")
    }
}
