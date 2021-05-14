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
                    .padding(.horizontal, 8.0)
                if (listShown == .Pools) {
                    PoolListView(viewModel: viewModel, showingRefresh: self.showingRefresh)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                }
                else {
                    SpotListView(spotModel: spotModel, showingRefresh: self.showingRefresh)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                }
                
            }
            .navigationBarTitle(Text("Badewaschel"))
            .navigationBarItems(
                leading: Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image.init(systemName: "gear")
                        .font(.title)
                }.sheet(isPresented: $showingDetail) {
                    if self.idiom == .pad {
                        SettingsView(poolModel: self.viewModel, spotModel: self.spotModel, options: self.viewModel.options!)
                    }
                    else {
                        SettingsView(poolModel: self.viewModel, spotModel: self.spotModel, options: self.viewModel.options!)
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
                            MapSelectionView()
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
            let poolAnnotation = CustomAnnotation()
            poolAnnotation.coordinate = CLLocationCoordinate2D(latitude: pool.geometry.coordinates[1], longitude: pool.geometry.coordinates[0])
            poolAnnotation.title = pool.properties.name
            poolAnnotation.pool = pool
            return poolAnnotation
        })
        return placemarks
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
