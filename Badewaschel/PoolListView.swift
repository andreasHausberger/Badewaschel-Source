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
    var body: some View {
        NavigationView {
            List(viewModel.pools, id: \.id) { pool in
                NavigationLink(destination: PoolDetailView(pool: pool)) {
                    PoolRow(pool: pool)
                }
            }
            .navigationBarTitle(Text("BadeWaschel"))
            .navigationBarItems(leading: Button(action: {
                self.showingDetail.toggle()
            }) {
                Image.init(systemName: "gear")
                    .font(.title)
            }.sheet(isPresented: $showingDetail) {
                    PoolSettingsView(model: self.viewModel)
            },
            trailing:
                NavigationLink(
                    destination:
                        MapView(latitude: 48.20, longitude: 16.37, name: "", allLocations: getAllLocations(), spanConstant: 0.25).navigationBarTitle("Alle Schwimmbäder")
                ) {
                    Image.init(systemName: "map")
                        .font(.title)
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
    var body: some View {
        HStack {
            Text(pool.properties.name).lineLimit(1)
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
