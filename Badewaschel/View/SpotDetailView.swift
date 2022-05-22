//
//  SpotDetailView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct SpotDetailView: View {
    var spot: FederalSpot?
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
            Section(header: Text("Informationen")) {
                List {
                    InfoView(name: "Name", content: spot?.badegewaessername ?? "Kein Name")
                    InfoView(name: "Adresse", content: spot?.strasseNummer)
                    InfoView(name: "Ort", content: spot?.plzOrt)
                    InfoView(name: "Geöffnet", content: spot?.isOpenText)
                }
            }
            
            Section(header: Text("Kontakt")) {
                List {
                    InfoView(name: "E-Mail", content: spot?.validEmail)
                        .onTapGesture {
                            if let email = spot?.validEmail {
                                let mailToLink = "mailto:\(email)"
                                self.openLink(link: mailToLink)
                            }
                        }
                    InfoView(name: "Telefon", content: spot?.telefon)
                        .onTapGesture {
                            if let phoneNumber = spot?.telefon {
                                let telLink = "tel:\(phoneNumber)"
                                self.openLink(link: telLink)
                            }
                        }
                }
            }
            
            Section(header: Text("Karte")) {
                List {
                    MapView(latitude: getLatLon().lat, longitude: getLatLon().lon, name: spot?.badegewaessername ?? "Kein Name")
                        .frame(height: 300)
                    Button("Route anzeigen") {
                        let mapsUrl = self.createMapsUrl()
                        self.openLink(link: mapsUrl)
                    }
                }
            }
            
            Section {
                ForEach(spot?.messwerte ?? [], id: \.self) { data in
                    MeasurementRow(measurement: data)
                }
            } header: {
                Text("Messungen der Wasserqualität")
            }
        }
        .navigationBarTitle(Text(spot?.badegewaessername ?? "Kein Name"))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    if let spot = self.spot {
                        self.model.setFavorite(id: spot.badegewaesserid)
                        self.isFavorite.toggle()
                    }
                } label: {
                    Image(systemName: self.isFavorite ? "heart.fill" : "heart")
                }
            }
        }
    }
    
    func getLatLon() -> (lat: Double, lon: Double) {
        let latitude = Double(self.spot?.latitude ?? "") ?? 0.0
        let longitude = Double(self.spot?.longitude ?? "") ?? 0.0
        return (lat: latitude, lon: longitude)
    }
    

    func createMapsUrl() -> String {
        let (latitude, longitude) = getLatLon()
        let mapsLink = "http://maps.apple.com?daddr=\(latitude),\(longitude)"
        return mapsLink
    }
}

struct MeasurementRow: View {
    var measurement: QualityMeasurement
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(measurement.date)
                    .fontWeight(.bold)
                Spacer()
                VStack (alignment: .trailing) {
                    Text("Wassertemperatur: \(measurement.waterTemperature.roundToTwoDecimalPoints()) °C")
                    Text("Enterokokken: \(measurement.enterokokken) KBE/100ml")
                    Text("E. Coli: \(measurement.eColi) KBE/100ml")
                    Text("Sichttiefe: \(measurement.sightLevel.roundToTwoDecimalPoints()) m")
                }
                .font(.footnote)
            }
            Text("Bewertung: \(measurement.qualityLabel)")
                .font(.footnote)
        }
        .padding(.vertical, 10)
    }
}



struct SpotDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SpotDetailView(spot: nil, model: SpotModel(), isFavorite: false)
    }
}
