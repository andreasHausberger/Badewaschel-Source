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
            NavigationLink(destination: PoolDetailView(pool: pool, model: self.viewModel, isFavorite: self.viewModel.isFavorite(id: pool.id))) {
                PoolRow(pool: pool, isFavorite: self.viewModel.isFavorite(id: pool.id), shouldDisplayCapacityLabel: self.viewModel.options?.shouldDisplayCapacityLabel)
            }
        }
        .pullToRefresh(isShowing: $showingRefresh) {
            self.viewModel.manuallyRefreshObjects {
                self.showingRefresh = false
            }
        }
    }
}

struct PoolListVIew_Previews: PreviewProvider {
    static var previews: some View {
        PoolListView(viewModel: PoolModel(), showingRefresh: false)
    }
}
