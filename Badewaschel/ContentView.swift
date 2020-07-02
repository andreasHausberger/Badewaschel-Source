//
//  ContentView.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI

struct PoolListView: View {
    @ObservedObject var viewModel = PoolModel()
    var body: some View {
        NavigationView {
            List(viewModel.pools, id: \.id) { pool in
                PoolRow(pool: pool)
            }
            .navigationBarTitle(Text("BadeWaschel"))
            .navigationBarItems(trailing: Button("Options", action: {
                
            }))
        }
    }
}

struct PoolRow: View {
    var pool: Pool
    var body: some View {
        Text(pool.properties.name)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PoolListView()
    }
}
