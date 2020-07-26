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
    private let dataManager = DataManager()
    @Published var spots = [Spot]()
    @Published var favorites = [String]()
    
    init() {
        DispatchQueue.main.async {
             self.networkManager.getAllSpots(completion: self.getSpotData(_:))
        }
    }
    
    //MARK: Data
    func getSpotData(_ response: SpotResponse) {
        DispatchQueue.main.async {
            self.spots = response.features
        }
    }
    
    func manuallyRefreshSpots(completion: @escaping () -> ()) {
        self.networkManager.getAllSpots { response in
            self.getSpotData(response)
            completion()
        }
    }
    
    //MARK: Favorites
    
    public func getFavorites() -> [Spot] {
        let favoriteIds = self.dataManager.getFavoriteIDs()
        
        let filteredPools = self.spots.filter( { favoriteIds.contains($0.id) })
        
        return filteredPools
    }
    
    public func setFavorite(id: String) {
        if !self.favorites.contains(id) {
            self.favorites.append(id)
        }
        else {
            self.favorites = self.favorites.filter ( { $0 != id })
        }
        self.dataManager.setFavorite(id: id)
    }
    
    public func isFavorite(id: String) -> Bool {
        return self.favorites.contains(id)
    }
    
    
}
