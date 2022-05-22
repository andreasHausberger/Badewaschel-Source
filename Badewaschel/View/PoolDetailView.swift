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
            }
            .navigationBarTitle(pool?.properties.name ?? "Pool Name")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if let pool = pool {
                            self.model.setFavorite(id: pool.id)
                            self.isFavorite.toggle()
                        }
                    } label: {
                        Image(systemName: self.isFavorite ? "heart.fill" : "heart")
                    }

                }
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
                Text(self.getDate(originalDate: auslastungsDate) ?? "Sonntag, 30. Februar 2020")
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
    
  
}


struct InfoView: View {
    var name: String
    var content: String?
    
    var body: some View {
        HStack {
            Text(name)
                .font(.headline)
            Spacer()
            Text(content ?? "Keine Informationen")
        }
    }
}


struct PoolDetailView_Previews: PreviewProvider {
    static let examplePool = BadewaschelMainView().poolModel.pools[0]
    static var previews: some View {
        PoolDetailView(pool: nil, model: PoolModel(), isFavorite: true)
    }
}
