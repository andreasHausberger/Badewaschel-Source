//
//  DataManager.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 02.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation

class DataManager: ObservableObject {
    
    @Published var favorites = [String]()
    
    private final let favoritesKey = "favorites"
    
    func getFavoriteIDs() -> [String] {
        if let favorites = UserDefaults.standard.array(forKey: self.favoritesKey) as? [String] {
            return favorites
        }
        return []
    }
    
    func setFavorite(id: String) {
        if var existingFavorites = UserDefaults.standard.array(forKey: self.favoritesKey) as? [String] {
            NSLog("Found existing favorites array")
            if !existingFavorites.contains(id) {
                existingFavorites.append(id)
                NSLog("Added Pool with id \(id) to favorites")
            }
            else {
                existingFavorites = existingFavorites.filter({ $0 != id })
                NSLog("Removed Pool with id \(id) from favorites")
            }
            UserDefaults.standard.set(existingFavorites, forKey: self.favoritesKey)

        }
        else {
            NSLog("Created new favorites array")
            let favorites = [id]
            UserDefaults.standard.set(favorites, forKey: self.favoritesKey)
        }
        
        self.favorites = UserDefaults.standard.array(forKey: self.favoritesKey) as! [String]
    }
}
