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
        VStack {
            List {
                ForEach(spotModel.federalStates, id: \.self) { state in
                    Section(state.stateName) {
                        ForEach(state.spots, id: \.self) { spot in
                            let isFavorite = spotModel.isFavorite(id: spot.badegewaesserid)
                            HStack {
                                if isFavorite {
                                    Text("❤️")
                                }
                                SpotRow(spot: spot, isFavorite: isFavorite, model: spotModel)
                            }
                        }
                    }
                }
                legend
            }
            .refreshable {
                self.spotModel.reloadFederalSpotData()
                self.showingRefresh.toggle()
            }
            .searchable(text: $spotModel.currentSearchText, prompt: Text("Name, Ort oder PLZ"))
        }
        .onAppear {
            self.spotModel.updateOptions()
        }
    }
    
    var legend: some View {
        Section("Legende") {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.green)
                    Spacer()
                    Text("Ausgezeichnete Wasserqualität")
                }
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("Gute Wasserqualität")
                }
                HStack {
                    Image(systemName: "hand.thumbsdown")
                        .foregroundColor(.orange)
                    Spacer()
                    Text("Mangelhafte Badegewässerqualität")
                }
                HStack {
                    Image(systemName: "hand.raised")
                        .foregroundColor(.red)
                    Spacer()
                    Text("Baden verboten / vom Baden wird abgeraten")
                }
            }
            .font(.footnote)
        }

    }
}


struct SpotRow: View {
    var spot: FederalSpot
    var isFavorite: Bool
    var model: SpotModel
    var body: some View {
        let measurement = getMostRecentMeasurement()
        let temperature = String.localizedStringWithFormat("%.1f", measurement?.waterTemperature ?? 0.0)
        NavigationLink(destination: SpotDetailView(spot: spot, model: self.model, isFavorite: self.isFavorite)) {
            HStack(alignment: .center) {
                getQualityIcon()
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
    
    func getMostRecentMeasurement() -> QualityMeasurement? {
        return spot.messwerte.sorted { mw1, mw2 in
            let date1 = Date.dateFromString(dateString: mw1.date, formatString: "dd.MM.yyyy")
            let date2 = Date.dateFromString(dateString: mw2.date, formatString: "dd.MM.yyyy")
            
            return date1! > date2!
        }
        .first
    }
    
    @ViewBuilder
    func getQualityIcon() -> some View {
        switch self.getMostRecentMeasurement()?.quality {
        case 1:
            Image(systemName: "hand.thumbsup")
                .foregroundColor(.green)
        case 2:
            Image(systemName: "hand.thumbsup")
                .foregroundColor(.yellow)
        case 3:
            Image(systemName: "hand.thumbsdown")
                .foregroundColor(.orange)
        case 4:
            Image(systemName: "hand.raised")
                .foregroundColor(.red)
        default:
            EmptyView()
        }
    }
}

struct SpotListView_Previews: PreviewProvider {
    static var previews: some View {
        SpotListView(spotModel: SpotModel(), showingRefresh: false)
    }
}
