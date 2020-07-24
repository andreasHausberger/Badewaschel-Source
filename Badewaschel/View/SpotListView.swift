//
//  SpotListView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct SpotListView: View {
    @ObservedObject var spotModel: SpotModel
    @State var showingRefresh: Bool
    var body: some View {
        List(spotModel.spots) { spot in
            SpotRow(spot: spot, isFavorite: self.spotModel.isFavorite(id: spot.id))
        }.pullToRefresh(isShowing: $showingRefresh) {
            self.spotModel.manuallyRefreshSpots {
                self.showingRefresh.toggle()
                print("Manually Refreshed Spots")
            }
        }.animation(.easeInOut)
    }
}

struct SpotRow: View {
    var spot: Spot
    var isFavorite: Bool
    var body: some View {
        NavigationLink(destination: SpotDetailView(spot: spot, isFavorite: self.isFavorite)) {
            HStack {
                Text(spot.properties.name + "\(self.isFavorite ? "❤️" : "")")
                Spacer()
                Text("\(String.localizedStringWithFormat("%.1f", spot.properties.wassertemperatur))°C")
            }
        }
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView(spotModel: SpotModel(), showingRefresh: false)
    }
}
