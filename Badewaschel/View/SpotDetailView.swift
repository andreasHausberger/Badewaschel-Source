//
//  SpotDetailView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct SpotDetailView: View {
    var spot: Spot?
    var model: SpotModel
    @State var isFavorite: Bool
    @State var displayWarning: Bool = false
    var body: some View {
        Form {
            if displayWarning {
                Section(header: Text("Warnung")) {
                    Text(Constants.warningText)
                        .foregroundColor(.red)
                }
            }
            Section(header: Text("Informationen"), footer: Text("* Messung pro 100 ml")) {
                List {
                    InfoView(name: "Name", content: spot?.properties.name ?? "Kein Name")
                    InfoView(name: "Bezirk", content: spot?.properties.bezirk.description ?? "Keine Information")
                    InfoView(name: "Wassertemperatur", content: spot?.properties.wassertemperatur?.description ?? "0 °C")
                    InfoView(name: "Sichttiefe", content: "\(spot?.properties.sichttiefe ?? 0) m")
                    InfoView(name: "Anzahl E.Coli *", content: spot?.properties.anzEcoli.description ?? "0")
                    InfoView(name: "Anzahl Enterokokken *", content: spot?.properties.anzEnterokokken.description ?? "0")
                }
            }
            
            Section(header: Text("Karte")) {
                List {
                    MapView(latitude: spot?.geometry.coordinates[1] ?? 0.0, longitude: spot?.geometry.coordinates[0] ?? 0.0, name: spot?.properties.name ?? "Kein Name")
                        .frame(height: 300)
                    Button("Route anzeigen") {
                        let mapsUrl = self.createMapsUrl()
                        self.openLink(link: mapsUrl)
                    }
                }
            }
            Section(header: Text("Letzte Aktualisierung")) {
                Text(getDate(originalDate: spot?.properties.untersuchungsdatum ?? "") ?? "Keine Information")
            }
        }.navigationBarTitle(Text(spot?.properties.name ?? "Kein Name"))
            .navigationBarItems(trailing: Button(action: {
                if let actualSpot = self.spot {
                    self.model.setFavorite(id: actualSpot.id)
                    self.isFavorite.toggle()
                }
                else {
                    print("Could not access Spot")
                }
            }) {
                return Image(systemName: self.isFavorite ? "heart.fill" : "heart").font(.title)
            })
        .onAppear {
            if getDaysSinceLastMeasurement() > 30.0 {
                displayWarning = true
            }
        }
    }
    
    func createMapsUrl() -> String {
        let latitude = spot?.geometry.coordinates[1] ?? 0.0
        let longitude = spot?.geometry.coordinates[0] ?? 0.0
        let mapsLink = "http://maps.apple.com?daddr=\(latitude),\(longitude)"
        return mapsLink
    }
    
    func getDaysSinceLastMeasurement() -> Double {
        if let date = Date.dateFromString(dateString: spot?.properties.untersuchungsdatum ?? "", formatString: "yyyy-MM-ddZ") {
            let distanceToNowInSeconds = date.distance(to: Date())
            let distanceInDays = distanceToNowInSeconds / 3600 / 24
            return floor(distanceInDays)
        }
        return 0
    }
}



struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailView(spot: nil, model: SpotModel(), isFavorite: false)
    }
}
