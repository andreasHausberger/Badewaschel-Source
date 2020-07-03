//
//  ContentView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import MapKit

struct PoolListView: View {
    @ObservedObject var viewModel = PoolModel()
    @State var showingDetail = false
    @State var showingMap = false
    var body: some View {
        NavigationView {
            List(viewModel.pools, id: \.id) { pool in
                NavigationLink(destination: PoolDetailView(pool: pool, model: self.viewModel, isFavorite: self.viewModel.isFavorite(id: pool.id))) {
                    PoolRow(pool: pool, isFavorite: self.viewModel.isFavorite(id: pool.id))
                }
            }
            .navigationBarTitle(Text("BadeWaschel"))
            .navigationBarItems(
                leading: Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image.init(systemName: "gear")
                        .font(.title)
                }.sheet(isPresented: $showingDetail) {
                    if self.idiom == .pad {
                        VStack {
                            Spacer()
                            Text("Einstellungen").font(.largeTitle)
                            PoolSettingsView(model: self.viewModel)
                        }
                    }
                    else {
                        NavigationView {
                            PoolSettingsView(model: self.viewModel)
                                .navigationBarTitle("Einstellungen")
                        }
                    }
                    
                },
                trailing:
                Button(action: {
                    self.showingMap.toggle()
                }) {
                    Image(systemName: "map").font(.title)
                }.sheet(isPresented: $showingMap) {
                    if self.idiom == .pad {
                        VStack {
                            Spacer()
                            Text("Alle Schwimmbäder").font(.largeTitle)
                            MapView(latitude: 48.20, longitude: 16.37, name: "", allLocations: self.getAllLocations(), spanConstant: 0.25)
                        }
                    }
                    else {
                        NavigationView {
                            MapView(latitude: 48.20, longitude: 16.37, name: "", allLocations: self.getAllLocations(), spanConstant: 0.25)
                                .navigationBarTitle("Alle Schwimmbäder")
                        }
                    }
                }
            )
            Text("Wähle ein Schwimmbad aus der Liste!")
        }
    }
    
    func getAllLocations() -> [MKPointAnnotation] {
        let pools = viewModel.pools
        
        let placemarks = pools.map( { pool -> MKPointAnnotation in
            let placemark = MKPointAnnotation()
            placemark.coordinate = CLLocationCoordinate2D(latitude: pool.geometry.coordinates[1], longitude: pool.geometry.coordinates[0])
            placemark.title = pool.properties.name
            return placemark
        })
        return placemarks
    }
}

struct PoolRow: View {
    var pool: Pool
    var isFavorite: Bool?
    var body: some View {
        HStack {
            
            Text(pool.properties.name).lineLimit(1)
            if self.isFavorite != nil && self.isFavorite! {
                Text("❤️")
            }
            Spacer()
            AuslastungsAmpel(auslastungInt: pool.properties.auslastungAmpelKategorie0)
                .frame(width: 32, height: 32, alignment: .trailing)
        }
    }
}

struct AuslastungsAmpel: View {
    var auslastungInt: Int
    var color: Color {
        switch auslastungInt {
        case 0:
            return .gray
        case 1:
            return .green
        case 2:
            return Color("LightGreen")
        case 3:
            return .yellow
        case 4:
            return .orange
        case 5:
            return .red
        default:
            return .gray
        }
    }
    var body: some View {
        Circle()
            .fill(self.color, style: FillStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PoolListView()
    }
}
