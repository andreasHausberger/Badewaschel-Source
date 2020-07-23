//
//  SpotModel.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation

class SpotModel: ObservableObject {
    
    private let networkManager = NetworkManager.shared()
    var spots: [Spot] = [Spot]()
    
    init() {
        DispatchQueue.main.async {
             self.networkManager.getAllSpots(completion: self.getSpotData(_:))
        }
    }
    
    func getSpotData(_ response: SpotResponse) {
        DispatchQueue.main.async {
            self.spots = response.features
        }
    }
    
}
