//
//  QuickMenuView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 07.05.22.
//  Copyright © 2022 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct QuickMenuView: View {
    @ObservedObject var poolModel: PoolModel
    @ObservedObject var spotModel: SpotModel
    
    @Binding var listShown: ShownList

    var body: some View {
        Menu {
            Menu("Sortierung") {
                MenuButton(labelText: "Name", imageName: "textformat") {
                    applySorting(.Name)
                }
                MenuButton(labelText: "Favoriten", imageName: "heart") {
                    applySorting(.Favorites)
                }
                MenuButton(labelText: "Nähe", imageName: "mappin.and.ellipse") {
                    applySorting(.Vicinity)
                }
                if self.listShown == .Pools {
                    MenuButton(labelText: "Auslastung", imageName: "person.3.sequence") {
                        poolModel.sortPools(sorting: .Capacity)
                    }
                }
            }
            Menu("Anzeige") {
                MenuButton(labelText: "Schwimmbäder", imageName: "") {
                    self.listShown = .Pools
                }
                MenuButton(labelText: "Badestellen", imageName: "") {
                    self.listShown = .Spots
                }
            }
        } label: {
            Label {
                Text("Anzeige")
            } icon: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
        }
    }
    
    func applySorting(_ sorting: Sorting) {
        switch self.listShown {
        case .Pools:
            poolModel.sortPools(sorting: sorting)
        case .Spots:
            spotModel.sortSpots(sorting: sorting)
        }
    }
}

fileprivate struct MenuButton: View {
    var labelText: String
    var imageName: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Label {
                Text(labelText)
            } icon: {
                Image(systemName: imageName)
            }

        }
    }
}
