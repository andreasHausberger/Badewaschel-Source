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
            SpotRow(spot: spot)
        }.pullToRefresh(isShowing: $showingRefresh) {
            print("does nothing")
            self.showingRefresh.toggle()
        }.animation(.easeInOut)
    }
}

struct SpotRow: View {
    var spot: Spot
    var body: some View {
        NavigationLink(destination: SpotDetailView(spot: spot)) {
            HStack {
                Text(spot.properties.name)
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
