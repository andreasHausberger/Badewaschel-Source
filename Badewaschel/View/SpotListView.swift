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
        List {
            ForEach(spotModel.federalStates, id: \.self) { state in
                Section(state.stateName) {
                    ForEach(state.spots, id: \.self) { spot in
                        let measurement = getMostRecentMeasurement(for: spot)
                        let temperature = String.localizedStringWithFormat("%.1f", measurement?.w ?? 0.0)
                        NavigationLink(destination: Text("Detail")) {
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text(spot.badegewaessername)
                                    Text("Letzte Messung: \(measurement?.d ?? "")")
                                        .font(.footnote)
                                }
                                Spacer()
                                Text("\(temperature) °C")
                            }
                        }
                    }
                }
            }
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
    
    func getMostRecentMeasurement(for federalSpot: Badegewaesser) -> Messwerte? {
        return federalSpot.messwerte.sorted { mw1, mw2 in
            let date1 = Date.dateFromString(dateString: mw1.d, formatString: "dd.MM.yyyy")
            let date2 = Date.dateFromString(dateString: mw2.d, formatString: "dd.MM.yyyy")
            
            return date1! > date2!
        }
        .first
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
