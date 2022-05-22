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
                        SpotRow(spot: spot, isFavorite: false, model: spotModel)
                    }
                }
            }
        }
        .refreshable {
            self.spotModel.reloadFederalSpotData()
            self.showingRefresh.toggle()
        }
        .searchable(text: $spotModel.currentSearchText, prompt: Text("Name, Ort oder PLZ"))
        .onAppear {
            self.spotModel.updateOptions()
        }
    }
}


struct SpotRow: View {
    var spot: FederalSpot
    var isFavorite: Bool
    var model: SpotModel
    var body: some View {
        let measurement = getMostRecentMeasurement(for: spot)
        let temperature = String.localizedStringWithFormat("%.1f", measurement?.waterTemperature ?? 0.0)
        NavigationLink(destination: SpotDetailView(spot: spot, model: self.model, isFavorite: self.isFavorite)) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(spot.badegewaessername)
                    Text("Letzte Messung: \(measurement?.date ?? "")")
                        .font(.footnote)
                }
                Spacer()
                Text("\(temperature) °C")
            }
        }
    }
    
    func getMostRecentMeasurement(for federalSpot: FederalSpot) -> QualityMeasurement? {
        return federalSpot.messwerte.sorted { mw1, mw2 in
            let date1 = Date.dateFromString(dateString: mw1.date, formatString: "dd.MM.yyyy")
            let date2 = Date.dateFromString(dateString: mw2.date, formatString: "dd.MM.yyyy")
            
            return date1! > date2!
        }
        .first
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView(spotModel: SpotModel(), showingRefresh: false)
    }
}
