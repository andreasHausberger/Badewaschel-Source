//
//  PoolDetailView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 28.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct PoolDetailView: View {
    var pool: Pool?
    var model: PoolModel
    @State var isFavorite: Bool
    var body: some View {
            Form {
                Section(header: Text("Auslastung")) {
                    List {
                        AuslastungsView(auslastungsInt: pool?.properties.auslastungAmpelKategorie0 ?? 0, auslastungsText: pool?.properties.auslastungAmpelKatTxt0 ?? "Keine Informationen", auslastungsDate: pool?.properties.auslastungTag0 ?? "")
                        AuslastungsView(auslastungsInt: pool?.properties.auslastungAmpelKategorie1 ?? 0, auslastungsText: pool?.properties.auslastungAmpelKatTxt1 ?? "Keine Informationen", auslastungsDate: pool?.properties.auslastungTag1 ?? "")
                        AuslastungsView(auslastungsInt: pool?.properties.auslastungAmpelKategorie2 ?? 0, auslastungsText: pool?.properties.auslastungAmpelKatTxt2 ?? "Keine Informationen", auslastungsDate: pool?.properties.auslastungTag2 ?? "")
                        AuslastungsView(auslastungsInt: pool?.properties.auslastungAmpelKategorie3 ?? 0, auslastungsText: pool?.properties.auslastungAmpelKatTxt3 ?? "Keine Informationen", auslastungsDate: pool?.properties.auslastungTag3 ?? "")
                    }
                }
                Section(header: Text("Informationen")) {
                    List {
                        InfoView(name: "Name", content: pool?.properties.name ?? "PoolName")
                        InfoView(name: "Adresse", content: pool?.properties.adresse ?? "Addresse")
                        InfoView(name: "Link", content: pool?.properties.weblink1 ?? "Link").onTapGesture {
                            self.openLink(link: self.pool?.properties.weblink1 ?? "")
                        }
                        InfoView(name: "Bezirk", content: pool?.properties.bezirk.description ?? "0")
                    }
                }
                Section(header: Text("Karte")) {
                    List {
                        MapView(latitude: pool?.geometry.coordinates[1] ?? 16.37, longitude: pool?.geometry.coordinates[0] ?? 48.20, name: pool?.properties.name ?? "Kein Name")
                            .frame(height: 300)
                        Button("Route anzeigen") {
                            let mapsUrl = self.createMapsUrl()
                            self.openLink(link: mapsUrl)
                        }
                        .frame(height: 32.0)
                    }
                }
            }.navigationBarTitle(pool?.properties.name ?? "Pool Name")
            
            .navigationBarItems(trailing: Button(action: {
                if let actualPool = self.pool {
                    self.model.setFavorite(id: actualPool.id)
                    self.isFavorite.toggle()

                    
                }
            }, label: {
                return Image(systemName: self.isFavorite ? "heart.fill" : "heart").font(.title)
            }))
    }
    
    func openLink(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            print("No link")
        }
    }
    
    func createMapsUrl() -> String {
        let address = pool?.properties.adresse
        let cleanAddress = address?.split(separator: ",", maxSplits: 1)[1].description ?? ""
        
        let uriEncodedAddress = cleanAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mapsLink = "http://maps.apple.com/?address=\(uriEncodedAddress ?? "")"
        return mapsLink
    }
}

struct AuslastungsView: View {
    var auslastungsInt: Int
    var auslastungsText: String
    var auslastungsDate: String
    var body: some View {
        VStack {
            HStack {
                Text(self.getDate() ?? "Sonntag, 30. Februar 2020")
                    .font(.footnote)
                Spacer()
            }
            HStack {
                AuslastungsAmpel(auslastungInt: auslastungsInt)
                    .frame(width: 32, height: 32, alignment: .leading)
                Spacer()
                Text(auslastungsText)
                
            }
        }
    }
    
    func getLocalDateString(date: Date) -> String {
        return date.description
    }
    
    func getDate() -> String? {
        let input = auslastungsDate
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de")
        formatter.dateFormat = "yyyy-MM-dd'Z'"
        if let date = formatter.date(from: input) {
            
            var dayComponent    = DateComponents()
            dayComponent.day = 1 // For removing one day (yesterday): -1
            let currentcalendar = Calendar.current
            let datePlusOneDay  = currentcalendar.date(byAdding: dayComponent, to: date)
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE, d. MMMM, yyyy"
            outputFormatter.locale = Locale(identifier: "de_AT")
            return(outputFormatter.string(from: datePlusOneDay ?? Date()))
        }
        return nil
    }
}


struct InfoView: View {
    var name: String
    var content: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
            Spacer()
            Text(content)
        }
    }
}


struct PoolDetailView_Previews: PreviewProvider {
    static let examplePool = BadewaschelMainView().viewModel.pools[0]
    static var previews: some View {
        PoolDetailView(pool: nil, model: PoolModel(), isFavorite: true)
    }
}
