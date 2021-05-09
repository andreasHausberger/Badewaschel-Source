//
//  SettingsView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 28.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var poolSorting: Sorting = .Name {
        didSet {
            self.poolModel.sorting = poolSorting
        }
    }
    @State var spotSorting: Sorting = .Name {
        didSet {
            self.spotModel.sorting = spotSorting
        }
    }
    
    @ObservedObject var poolModel: PoolModel
    @ObservedObject var spotModel: SpotModel
    @ObservedObject var dataManager: DataManager = DataManager()
    
    @State var options: UserOptions
    
    @State var switchIsOn = false
    
    var favoritePools: [Pool] {
        self.poolModel.getFavorites()
    }
    var body: some View {
        VStack {
            HStack {
                Text("Einstellungen")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                Button("Speichern") {
                    self.poolModel.sortPools(sorting: self.options.poolSorting)
                    self.spotModel.sortSpots(sorting: self.options.spotSorting)
                    self.dataManager.setUserOptions(options: self.options)
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.top, 15.0)
            .padding(.horizontal, 10.0)
            Form {
                Section(header: Text("Sortierung der Schwimmbäder")) {
                    Picker("Nach", selection: $options.poolSorting) {
                        Text("Name").tag(Sorting.Name)
                        Text("Favoriten").tag(Sorting.Favorites)
                        if (self.poolModel.locationIsAvailable) {
                            Text("Nähe").tag(Sorting.Vicinity)
                        }
                        Text("Auslastung").tag(Sorting.Capacity)
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Sortierung der Badestellen")) {
                    Picker("Nach", selection: $options.spotSorting) {
                        Text("Name").tag(Sorting.Name)
                        Text("Favoriten").tag(Sorting.Favorites)
                        if (self.poolModel.locationIsAvailable) {
                            Text("Nähe").tag(Sorting.Vicinity)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Listen-Einstellungen")) {
                    HStack {
                        Toggle(isOn: $options.shouldDisplayCapacityLabel) {
                            Text("Auslastungs-Text anzeigen")
                        }
                    }
                }
                Section(header: Text("Meine Favoriten")) {
                    List(self.favoritePools) { pool in
                        PoolRow(pool: pool)
                    }
                }
                
                Section(header: Text("Ortung")) {
                    Text("Die Ortungsdienste sind derzeit \(self.poolModel.locationIsAvailable ? "aktiviert" : "deaktiviert")")
                }
                
                Section(header: Text("Letzte Aktualisierung")) {
                    Text("Zeitpunkt der letzten Aktualisierung: \(self.poolModel.lastUpdate)")
                }
                
                Section(header: Text("Quellen")) {
                    Text("Datenquelle: Stadt Wien – https://data.wien.gv.at").onTapGesture {
                        if let url = URL(string: "https://data.wien.gv.at") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    Text("Die Daten werden aus der oben genannten Quelle entnommen und unterliegen keinen inhaltlichen Änderungen, die durch die App vorgenommen wurden.")
                }
                
                Section(header: Text("Art & Design")) {
                    HStack {
                        Text("App Logo")
                        Spacer()
                        Text("Yizhou \"Andi\" Cui")
                    }
                    HStack {
                        Text("Launch Screen")
                        Spacer()
                        Text("Louise Popl")
                    }
                }
            }
            .onAppear {
                self.options =  self.dataManager.getUserOptions()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(poolModel: PoolModel(), spotModel: SpotModel(), options: UserOptions(poolSorting: .Name, spotSorting: .Name, shouldDisplayCapacityLabel: false))
    }
}


