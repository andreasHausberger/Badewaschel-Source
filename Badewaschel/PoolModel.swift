//
//  PoolModel.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 27.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import CoreLocation

public class PoolModel: ObservableObject {
    
    public var sorting: Sorting = .Name 
    private let networkManager = NetworkManager.shared()
    private var locationManager = LocationManager()
    private var dataManager = DataManager()
    
    @Published var pools = [Pool]()
    
    @Published var lastUpdate = ""
    
    public var location: CLLocation? {
        self.locationManager.userLocation
    }

    public var locationIsAvailable: Bool {
        self.locationManager.locationIsAvailable
    }
    
    @Published var favorites = [String]()
    
    init() {
        self.networkManager.getAllPools(completion: self.getPoolData(_:))
        self.favorites = self.dataManager.getFavoriteIDs()
    }
    
    //MARK: Pool Data & Sorting
    
    func getPoolData(_ response:PoolResponse) {
        DispatchQueue.main.async {
            self.pools = response.features
            self.sortPools(sorting: .Name)
            let lastUpdateStrings = self.pools.map( { $0.properties.timestampModifiedFormat })
            
            for string in lastUpdateStrings {
                if let actualString = string {
                    self.lastUpdate = actualString
                    return
                }
            }
        }
    }
    
    public func sortPools(sorting: Sorting) {
        switch sorting {
        case .Favorites:
            print("Not yet implemented!")
        case .Vicinity:
            self.pools.sort(by: { self.sortPoolsByVicinity(pool1: $0, pool2: $1) })
        case .Capacity:
            self.pools.sort(by: { self.sortPoolsByCapacity(pool1: $0, pool2: $1) })
        case .Name:
            self.pools.sort(by: {p1, p2 in
                p1.properties.name < p2.properties.name
            })
        }
    }
    
    private func sortPoolsByCapacity(pool1: Pool, pool2: Pool) -> Bool {
        let cap1 = pool1.properties.auslastungAmpelKategorie0
        let cap2 = pool2.properties.auslastungAmpelKategorie0
        
        if cap1 > 0 && cap2 <= 0 {
            return true
        }
        if cap1 <= 0 && cap2 > 0 {
            return false
        }
        return cap1 < cap2
    }
    
    private func sortPoolsByVicinity(pool1: Pool, pool2: Pool) -> Bool {
        if let userLocation = self.location {
            let location1 = CLLocation(latitude: pool1.geometry.coordinates[1], longitude: pool1.geometry.coordinates[0])
            let location2 = CLLocation(latitude: pool2.geometry.coordinates[1], longitude: pool2.geometry.coordinates[0])
            
            let distance1 = userLocation.distance(from: location1)
            let distance2 = userLocation.distance(from: location2)
            
            return distance1 < distance2
        }
        return false
    }
    
    //MARK: Favorites
    
    public func getFavorites() -> [Pool] {
        let favoriteIds = self.dataManager.getFavoriteIDs()
        
        let filteredPools = self.pools.filter( { favoriteIds.contains($0.id) })
        
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

public enum Sorting {
    case Favorites;
    case Vicinity;
    case Capacity;
    case Name;
}
