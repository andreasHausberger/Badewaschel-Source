//
//  SpotListView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI
import Combine
struct SpotListView: View {
    
    var subs: Set<AnyCancellable> = []
    
    @ObservedObject var spotModel: SpotModel
    @State var currentSpots: [Spot] = []
    @State var showingRefresh: Bool
    var body: some View {
        List(spotModel.spots) { spot in
            SpotRow(spot: spot, isFavorite: self.spotModel.isFavorite(id: spot.id), model: self.spotModel)
        }
        .refreshable {
            self.spotModel.loadSpots()
            self.showingRefresh.toggle()
        }
        .onAppear {
            self.spotModel.updateOptions()
            self.spotModel.loadSpots()
        }
    }
}

struct SpotRow: View {
    var spot: Spot
    var isFavorite: Bool
    var model: SpotModel
    var body: some View {
        NavigationLink(destination: SpotDetailView(spot: spot, model: self.model, isFavorite: self.isFavorite)) {
            HStack {
                Text(spot.properties.name + " \(self.isFavorite ? "❤️" : "")")
                Spacer()
                Text("\(String.localizedStringWithFormat("%.1f", spot.properties.wassertemperatur ?? 0.0))°C")
            }
        }
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView(spotModel: SpotModel(), showingRefresh: false)
    }
}
