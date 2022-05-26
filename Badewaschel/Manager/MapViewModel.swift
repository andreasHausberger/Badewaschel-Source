//
//  MapViewModel.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.05.22.
//  Copyright © 2022 Andreas Hausberger. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class MapViewModel: ObservableObject {
    
    private var subs: Set<AnyCancellable> = []
    
    @ObservedObject var poolModel = PoolModel()
    @ObservedObject var spotModel = SpotModel()
    
    @Published var currentAnnotations: [CustomAnnotation] = []
    
    @Published var poolAnnotations: [CustomAnnotation] = []
    @Published var spotAnnotations: [CustomAnnotation] = []
    @Published var selection: MapSelection = .Pools
    
    init() {
        poolModel.$pools
            .tryMap { pools in
                pools.map { pool in
                    CustomAnnotation(pool: pool)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    break
                }
            } receiveValue: { annotations in
                self.poolAnnotations = annotations
                if self.selection == .Pools {
                    self.currentAnnotations = self.poolAnnotations
                }
            }
            .store(in: &subs)
        
        spotModel.$federalStates
            .map { states in
                return states.flatMap { $0.spots }
            }
            .map { spots in
                spots.map { CustomAnnotation(spot: $0) }
            }
            .receive(on: DispatchQueue.main)
            .sink { annotations in
                self.spotAnnotations = annotations
            }
            .store(in: &subs)
        
        $selection
            .receive(on: DispatchQueue.main)
            .sink { selection in
                switch selection {
                case .Pools:
                    self.currentAnnotations = self.poolAnnotations
                case .Spots:
                    self.currentAnnotations = self.spotAnnotations
                }
            }
            .store(in: &subs)
    }
}
