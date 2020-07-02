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
                        List {
                            Text("Pool")
                        }
                    }
                    
                    Section(header: Text("Ortung")) {
                        Text("Die Ortungsdienste sind derzeit \(self.model.locationIsAvailable ? "aktiviert" : "deaktiviert")")
                    }
                    HStack {
                        Spacer()
                        Button("Speichern") {
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


