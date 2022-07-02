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
    @ObservedObject var viewModel = MapViewModel()
    @State var presentingAnnotation: CustomAnnotation? = nil
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: Constants.Map.center, latitudinalMeters: Constants.Map.latMeters, longitudinalMeters: Constants.Map.lonMeters)
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Picker", selection: $viewModel.selection) {
                    ForEach(MapSelection.allCases, id: \.self) { selection in
                        Text(selection.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: $viewModel.currentAnnotations.wrappedValue, annotationContent: { (item: CustomAnnotation) in
                    MapAnnotation(coordinate: item.location) {
                        PinView(item: item, displayTitle: .constant(self.presentingAnnotation == item))
                            .onTapGesture {
                                withAnimation {
                                    self.presentingAnnotation = item
                                }
                            }
                    }
                })
            }
            .navigationTitle(Text("Kartenübersicht"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Fertig")
                    }
                }
            }
        }
        .actionSheet(item: $presentingAnnotation) { (item: CustomAnnotation) in
            ActionSheet(title: Text(item.getName()), message: nil, buttons: [
                ActionSheet.Button.default(Text("Route anzeigen"), action: {
                    self.openAddress(for: item)
                }),
                ActionSheet.Button.cancel()
            ])
        }
        
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
            let coordinates = spot.getLatLon()
            
            mapsLink = "http://maps.apple.com/?daddr=\(coordinates.lat),\(coordinates.lon)"
        }
        if let url = URL(string: mapsLink) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct PinView: View {
    var item: CustomAnnotation
    @Binding public var displayTitle: Bool
    var body: some View {
        ZStack {
            if (displayTitle) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.white)
                    Text(item.pool?.properties.name ?? item.spot?.badegewaessername ?? "")
                        .font(.footnote)
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
    }
}

enum MapSelection: String, CaseIterable, Equatable {
    case Pools = "Schwimmbäder"
    case Spots = "Badestellen"
}
