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
    var delegate = MapViewDelegate()
    
    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView(frame: .zero)
        view.register(PoolAnnotation.self, forAnnotationViewWithReuseIdentifier: "Annotation")
        view.delegate = self.delegate
        return view
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
        uiView.showsUserLocation = true
        
    }
    
    
    var spanConstant: Double = 0.0025
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(latitude: 48.20, longitude: 16.37, name: "PreviewName")
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        guard let poolAnnotation = annotation as? PoolAnnotation else { return nil }
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        pin.pinTintColor = UIColor.getColorForCapacity(capacity: poolAnnotation.pool?.properties.auslastungAmpelKategorie0 ?? 0)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("Tapped \(control)")
        if let poolAnnotation = view.annotation as? PoolAnnotation {
            let address = poolAnnotation.pool?.properties.adresse
            
            let cleanAddress = address?.split(separator: ",", maxSplits: 1)[1].description ?? ""
            
            let uriEncodedAddress = cleanAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let mapsLink = "http://maps.apple.com/?address=\(uriEncodedAddress ?? "")"
            
            if let url = URL(string: mapsLink) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

struct MapsNavigationLink: View {
    var pool: Pool?
    var isFavorite: Bool
    var model: PoolModel
    var body: some View {
        NavigationLink(destination: PoolDetailView(pool: pool, model: model, isFavorite: isFavorite)) {
            Text("Hrmpf")
        }
    }
    
    
}
