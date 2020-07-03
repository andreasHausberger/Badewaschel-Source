//
//  SettingsView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 28.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct PoolSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var sorting: Sorting = .Name {
        didSet {
            self.model.sorting = sorting
        }
    }
    @ObservedObject var model: PoolModel
    
    var favoritePools: [Pool] {
        self.model.getFavorites()
    }
    var body: some View {
        HStack {
            VStack {
                Form {
                    Section(header: Text("Sortierung")) {
                        
                            Picker("Nach", selection: $sorting) {
                                Text("Name").tag(Sorting.Name)
                                Text("Favoriten").tag(Sorting.Favorites)
                                if (self.model.locationIsAvailable) {
                                    Text("Nähe").tag(Sorting.Vicinity)
                                }
                                Text("Auslastung").tag(Sorting.Capacity)
                            }.pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Meine Favoriten")) {
                        List(self.favoritePools) { pool in
                            if self.idiom == .pad {
                                PoolRow(pool: pool)
                            }
                            else {
                                NavigationLink(destination: PoolDetailView(pool: pool, model: self.model, isFavorite: self.model.isFavorite(id: pool.id))) {
                                    PoolRow(pool: pool)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Ortung")) {
                        Text("Die Ortungsdienste sind derzeit \(self.model.locationIsAvailable ? "aktiviert" : "deaktiviert")")
                    }
                    
                    Section(header: Text("Letzte Aktualisierung")) {
                        Text("Zeitpunkt der letzten Aktualisierung: \(self.model.lastUpdate)")
                    }
                    
                    Section(header: Text("Quellen")) {
                        Text("Datenquelle: Stadt Wien – https://data.wien.gv.at").onTapGesture {
                            if let url = URL(string: "https://data.wien.gv.at") {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                        Text("Die Daten werden aus der oben genannten Quelle entnommen und unterliegen keinen inhaltlichen Änderungen, die durch die App vorgenommen wurden.")
                        }
                    HStack {
                        Spacer()
                        Button("Speichern & Anwenden") {
                            self.model.sortPools(sorting: self.sorting)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PoolSettingsView(model: PoolModel())
    }
}


