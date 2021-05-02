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
    private final let poolSortingOptionsKey = "sortingOptions"
    private final let spotSortingOptionsKey = "spotSortingOptions"
    private final let displayKey = "displayOptions"
    
    //MARK: Favorites
    
    func getFavoriteIDs() -> [String] {
        if let favorites = UserDefaults.standard.array(forKey: self.favoritesKey) as? [String] {
            return favorites
        }
        return []
    }
    
    
    /// Sets the object with the gven ID as favorite
    /// - Parameter id: ID of the object.
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
    
    //MARK: UserOptions
    
    func setUserOptions(options: UserOptions) {
        
        UserDefaults.standard.set(options.shouldDisplayCapacityLabel, forKey: self.displayKey)
        UserDefaults.standard.set(options.poolSorting.rawValue, forKey: self.poolSortingOptionsKey)
    }
    
    func getUserOptions() -> UserOptions {
        let options = UserOptions(poolSorting: .Name, spotSorting: .Name, shouldDisplayCapacityLabel: false)
        
        if let display = UserDefaults.standard.object(forKey: self.displayKey) as? Bool,
            let poolSorting = UserDefaults.standard.object(forKey: self.poolSortingOptionsKey) as? Int {
            let spotSorting = UserDefaults.standard.object(forKey: self.spotSortingOptionsKey) as? Int ?? 0
            
            return UserOptions(poolSorting: poolSorting, spotSorting: spotSorting, shouldDisplayCapacityLabel: display)
            
        }
        return options
    }
}
