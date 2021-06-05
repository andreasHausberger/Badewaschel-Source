//
//  PoolListVIew.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct PoolListView: View {
    @ObservedObject var viewModel: PoolModel
    @State var showingRefresh: Bool
    var body: some View {
        List(viewModel.pools, id: \.id) { pool in
            NavigationLink(destination:
                            PoolDetailView(pool: pool,
                                           model: self.viewModel,
                                           isFavorite: self.viewModel.isFavorite(id: pool.id)
                            )
            )
            {
                PoolRow(pool: pool,
                        isFavorite: self.viewModel.isFavorite(id: pool.id),
                        shouldDisplayCapacityLabel: self.viewModel.options?.shouldDisplayCapacityLabel
                )
            }
        }
        .pullToRefresh(isShowing: $showingRefresh) {
            self.viewModel.manuallyRefreshObjects {
                self.showingRefresh = false
            }
        }
        .animation(.easeInOut)
        .onAppear {
            self.viewModel.loadPoolData()
        }
    }
}

struct PoolRow: View {
    var pool: Pool
    var isFavorite: Bool?
    var shouldDisplayCapacityLabel: Bool?
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(pool.properties.name).multilineTextAlignment(.leading).lineLimit(1)
                    if self.isFavorite != nil && self.isFavorite! {
                        Text("❤️")
                    }
                    Spacer()
                }
                if (self.shouldDisplayCapacityLabel != nil && self.shouldDisplayCapacityLabel!) {
                    HStack {
                        Text(pool.properties.auslastungAmpelKatTxt0 ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
            Spacer()
            AuslastungsAmpel(auslastungInt: pool.properties.auslastungAmpelKategorie0)
                .frame(width: 32, height: 32, alignment: .trailing)
        }
        .accessibility(label: Text("\(pool.properties.name). Aktuelle Auslastung: \(pool.properties.auslastungAmpelKatTxt0 ?? "Keine Information")"))
    }
}


struct PoolListView_Previews: PreviewProvider {
    static var previews: some View {
        PoolListView(viewModel: PoolModel(), showingRefresh: false)
    }
}
