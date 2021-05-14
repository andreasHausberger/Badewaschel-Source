//
//  MapSelectionView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 14.05.21.
//  Copyright © 2021 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import Combine
import MapKit

struct MapSelectionView: View {
    @State var selection: MapSelection = .Pools
    @State var navTitle: String = "Alle Schwimmbäder"
    @State var annotations: [CustomAnnotation] = []
    @State private var subs: Set<AnyCancellable> = []
    @State var presentingAnnotation: CustomAnnotation? = nil
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: Constants.Map.center, latitudinalMeters: Constants.Map.latMeters, longitudinalMeters: Constants.Map.lonMeters)
    
    var body: some View {
        VStack {
            Picker("Picker", selection: $selection) {
                ForEach(MapSelection.allCases, id: \.self) { selection in
                    Text(selection.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: annotations, annotationContent: { (item: CustomAnnotation) in
                MapAnnotation(coordinate: item.coordinate) {
                    PinView(item: item) { item in
                        self.presentingAnnotation = item
                    }
                }
            })
        }
        .onAppear {
            self.loadAnnotations(for: .Pools)
        }
        .onChange(of: selection) {selection in
            self.loadAnnotations(for: selection)
        }
        .navigationBarTitle(self.navTitle)
        .actionSheet(item: $presentingAnnotation) { (item: CustomAnnotation) in
            ActionSheet(title: Text(item.getName()), message: nil, buttons: [
                ActionSheet.Button.default(Text("Route anzeigen"), action: {
                    self.openAddress(for: item)
                }),
                ActionSheet.Button.cancel()
            ])
        }
        
    }
    
    private func loadAnnotations(for selection: MapSelection) {
        self.annotations = []
        switch selection {
        case .Pools:
            self.navTitle = "Alle Schwimmbäder"
            self.loadPoolAnnotations()
            break
        case .Spots:
            self.navTitle = "Alle Badestellen"
            self.loadSpotAnnotations()
            break
        }
    }
    
    private func loadPoolAnnotations() {
        let poolModel = PoolModel()
        
        poolModel.getPoolPublisher()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("error: \(error)")
                }
            }, receiveValue: { pools in
                let placemarks = pools.map { pool -> CustomAnnotation in
                    let poolAnnotation =  CustomAnnotation()
                    poolAnnotation.coordinate = CLLocationCoordinate2D(latitude: pool.geometry.coordinates[1], longitude: pool.geometry.coordinates[0])
                    poolAnnotation.title = pool.properties.name
                    poolAnnotation.pool = pool
                    return poolAnnotation
                }
                self.annotations = placemarks
            })
            .store(in: &subs)
    }
    
    private func loadSpotAnnotations() {
        let spotModel = SpotModel()
        
        spotModel.getSpotPublisher()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("error: \(error)")
                }
            }, receiveValue: { spots in
                let placemarks = spots.map( { spot -> CustomAnnotation in
                    let spotAnnotation = CustomAnnotation()
                    spotAnnotation.coordinate = CLLocationCoordinate2D(latitude: spot.geometry.coordinates[1], longitude: spot.geometry.coordinates[0])
                    spotAnnotation.title = spot.properties.name
                    spotAnnotation.spot = spot
                    return spotAnnotation
                })
                self.annotations = placemarks
            })
            .store(in: &subs)
    }
    
    private func openAddress(for item: CustomAnnotation) {
        var mapsLink = ""
        if let pool = item.pool,
           item.spot == nil {
            let addressString = pool.properties.adresse
            
            let cleanAddress = addressString.split(separator: ",", maxSplits: 1)[1].description
            
            let uriEncodedAddress = cleanAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            mapsLink = "http://maps.apple.com/?address=\(uriEncodedAddress ?? "")"
        }
        else if let spot = item.spot {
            let coordinates = spot.geometry.coordinates
            
            mapsLink = "http://maps.apple.com/?daddr=\(coordinates[1]),\(coordinates[0])"
        }
        if let url = URL(string: mapsLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct PinView: View {
    var item: CustomAnnotation
    @State public var displayTitle: Bool = false
    public let presentAnnotation: (CustomAnnotation) -> ()
    var body: some View {
        ZStack {
            if (displayTitle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.white)
                    Text(item.pool?.properties.name ?? item.spot?.properties.name ?? "")
                        .font(.system(size: 10))
                        .padding(1)
                }
                .frame(width: 90, height: 60, alignment: .top)
                .offset(x: 0, y: -60)
                
            }
            Group {
                Image(systemName: "mappin")
                    .resizable()
                    .frame(width: 15, height: 40, alignment: .center)
            }
            .foregroundColor(item.getColor())
            
        }
//        .frame(width: 80, height: 80)
        .onTapGesture {
            withAnimation {
                self.displayTitle.toggle()
                self.presentAnnotation(item)
            }
        }
    }
}

enum MapSelection: String, CaseIterable, Equatable {
    case Pools = "Schwimmbäder"
    case Spots = "Badestellen"
}
