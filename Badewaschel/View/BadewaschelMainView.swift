//
//  ContentView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import MapKit
import SwiftUIRefresh

struct BadewaschelMainView: View {
    
    enum ActiveSheet: String, Identifiable {
        var id: String {
            return self.rawValue
        }
        
        case settings, map
    }
    
    @ObservedObject var poolModel = PoolModel()
    @ObservedObject var spotModel = SpotModel()
    
    @State var showingDetail = false
    @State var showingRefresh = false
    @State var showingMap = false
    @State var listShown: ShownList = .Pools
    
    @State var activeSheet: ActiveSheet?
    
    var body: some View {
        NavigationView {
            ZStack {
                if listShown == .Pools {
                    PoolListView(viewModel: poolModel, showingRefresh: self.showingRefresh)
                        .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
                }
                else {
                    SpotListView(spotModel: spotModel, showingRefresh: self.showingRefresh)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))) 
                }
            }
            .navigationBarTitle(listShown.rawValue)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.activeSheet = .settings
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        self.activeSheet = .map
                    } label: {
                        Image(systemName: "map")
                    }
                    QuickMenuView(poolModel: poolModel, spotModel: spotModel, listShown: $listShown)
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .settings:
                    SettingsView(poolModel: self.poolModel, spotModel: self.spotModel, options: self.poolModel.options!)
                case .map:
                    MapSelectionView()

                }
            }
            Text("Wähle ein Schwimmbad aus der Liste!")
        }
    }
}


struct AuslastungsAmpel: View {
    var auslastungInt: Int
    var color: Color {
        Color(UIColor.getColorForCapacity(capacity: auslastungInt))
    }
    var body: some View {
        Circle()
            .fill(self.color, style: FillStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BadewaschelMainView()
    }
}

enum ShownList: String {
    case Pools = "Schwimmbäder"
    case Spots = "Badestellen"
}
