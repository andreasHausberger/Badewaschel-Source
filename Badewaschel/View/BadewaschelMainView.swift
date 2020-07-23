//
//  ContentView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftUIRefresh

struct BadewaschelMainView: View {
    @ObservedObject var viewModel = PoolModel()
    @ObservedObject var spotModel = SpotModel()
    @State var showingDetail = false
    @State var showingRefresh = false
    @State var showingMap = false
    @State var listShown: ShownList = .Pools
    var body: some View {
        NavigationView {
            VStack {
                Picker("Anzeige", selection: $listShown) {
                    Text("Schwimmbäder").tag(ShownList.Pools)
                    Text("Badestellen").tag(ShownList.Spots)
                }.pickerStyle(SegmentedPickerStyle())
                if (listShown == .Pools) {
                    PoolListView(viewModel: viewModel, showingRefresh: self.showingRefresh)
                }
                else {
                    VStack {
                        SpotListView(spotModel: spotModel, showingRefresh: self.showingRefresh)
                    }
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
                        PoolSettingsView(model: self.viewModel, options: self.viewModel.options!)
                    }
                    else {
                        PoolSettingsView(model: self.viewModel, options: self.viewModel.options!)
                            .navigationBarTitle("Einstellungen")
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
                            MapView(latitude: 48.20, longitude: 16.37, name: "", allLocations: self.getAllAnnotations(), spanConstant: 0.25)
                        }
                    }
                    else {
                        NavigationView {
                            MapView(latitude: 48.20, longitude: 16.37, name: "", allLocations: self.getAllAnnotations(), spanConstant: 0.25)
                                .navigationBarTitle("Alle Schwimmbäder")
                        }
                    }
                }
            )
            Text("Wähle ein Schwimmbad aus der Liste!")
        }
    }
    
    func getAllAnnotations() -> [MKPointAnnotation] {
        let pools = viewModel.pools
        
        let placemarks = pools.map( { pool -> MKPointAnnotation in
            let poolAnnotation = PoolAnnotation()
            poolAnnotation.coordinate = CLLocationCoordinate2D(latitude: pool.geometry.coordinates[1], longitude: pool.geometry.coordinates[0])
            poolAnnotation.title = pool.properties.name
            poolAnnotation.pool = pool
            return poolAnnotation
        })
        return placemarks
    }
}

struct PoolRow: View {
    var pool: Pool
    var isFavorite: Bool?
    var shouldDisplayCapacityLabel: Bool?
    var body: some View {
        VStack {
            HStack {
                Text(pool.properties.name).multilineTextAlignment(.leading).lineLimit(1)
                if self.isFavorite != nil && self.isFavorite! {
                    Text("❤️")
                }
                
                Spacer()
                AuslastungsAmpel(auslastungInt: pool.properties.auslastungAmpelKategorie0)
                    .frame(width: 32, height: 32, alignment: .trailing)
            }
            if (self.shouldDisplayCapacityLabel != nil && self.shouldDisplayCapacityLabel!) {
                Text(pool.properties.auslastungAmpelKatTxt0 ?? "").font(.footnote)
            }
            
        }
        
    }
}

struct AuslastungsAmpel: View {
    var auslastungInt: Int
    var color: Color {
        Color(UIColor.getColorForCapacity(capacity: auslastungInt))
    }
    var body: some View {
        Circle()
            .fill(self.color, style: FillStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BadewaschelMainView()
    }
}

enum ShownList {
    case Pools
    case Spots
}
