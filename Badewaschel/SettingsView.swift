//
//  SettingsView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 28.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct PoolSettingsView: View {
    @State var sorting: Sorting = .None
    @ObservedObject var model: PoolModel
    var body: some View {
        Form {
            Section(header: Text("Sortieren")) {
                Picker("Nach", selection: $sorting) {
                    Text("Keine").tag(Sorting.None)
                    Text("Favoriten").tag(Sorting.Favorites)
                    Text("Nähe").tag(Sorting.Vicinity)
                    Text("Auslastung").tag(Sorting.Capacity)
                }.pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Meine Favoriten")) {
                List {
                    Text("Pool")
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


