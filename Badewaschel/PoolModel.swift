//
//  PoolModel.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 27.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import CoreLocation
import Flyweight
import Combine

class PoolModel: ObservableObject {
    
    var subs: Set<AnyCancellable> = []
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
    
    @Published var options: UserOptions?
    
    init() {
        self.networkManager.getAllPools(completion: self.getPoolData(_:))
        self.favorites = self.dataManager.getFavoriteIDs()
        self.options = self.dataManager.getUserOptions()
    }
    
    /**
    Used for manual refresh of Lists. Repeats data call.
    - parameter completion: Void Function that takes no arguments.Should be used for UI completion, e.g. disappearing a loading spinner.
    */
    func manuallyRefreshObjects(completion: @escaping () -> ()) {
        self.loadPoolData()
        completion()
    }
    
    //MARK: Pool Data & Sorting
    
    func loadPoolData() {
        self.getPoolPublisher()?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("error: \(error)")
                }
            }, receiveValue: { pools in
                DispatchQueue.main.async {
                    self.pools = pools
                    self.getOptions()
                    self.sorting = self.options?.poolSorting ?? .Name
                    self.sortPools(sorting: self.sorting)
                }
            })
            .store(in: &subs)
    }
    
    func getPoolData(_ response:PoolResponse) {
        DispatchQueue.main.async {
            self.pools = response.features
            if self.options != nil {
                self.sortPools(sorting: self.options!.poolSorting)
            }
            else {
                self.sortPools(sorting: .Name)
            }
            let lastUpdateStrings = self.pools.map( { $0.properties.timestampModifiedFormat })
            
            for string in lastUpdateStrings {
                if let actualString = string {
                    self.lastUpdate = actualString
                    return
                }
            }
        }
    }
    
    func getPoolPublisher() -> AnyPublisher<[Pool], APIError>? {
        do {
            let publisher: AnyPublisher<PoolResponse, APIError> = try Network.get(urlString: Constants.poolURL)
            return publisher
                .map { $0.features }
                .eraseToAnyPublisher()
        }
        catch let error {
            print("error: \(error)")
        }
        return nil
    }
    
    
    
    public func sortPools(sorting: Sorting) {
        switch sorting {
        case .Favorites:
            self.pools.sort(by: { self.sortPoolsByFavorites(pool1: $0, pool2: $1) })
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
    
    private func sortPoolsByFavorites(pool1: Pool, pool2: Pool) -> Bool {
        let pool1isFavorite = self.favorites.contains(pool1.id)
        let pool2isFavorite = self.favorites.contains(pool2.id)
        
        if pool1isFavorite && !pool2isFavorite { return true }
        if !pool1isFavorite && pool2isFavorite { return true }
        
        return pool1.properties.name < pool2.properties.name
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
    
    //MARK: Options
    
    public func getOptions() {
        self.options = self.dataManager.getUserOptions()
    }
}

public enum Sorting: Int {
    case Favorites = 1;
    case Vicinity = 2;
    case Capacity = 3;
    case Name = 0;
}

public struct UserOptions {
    var poolSorting: Sorting
    var spotSorting: Sorting
    var shouldDisplayCapacityLabel: Bool
    
    init(poolSorting: Int, spotSorting: Int, shouldDisplayCapacityLabel: Bool) {
        self.poolSorting = Sorting(rawValue: poolSorting) ?? .Name
        self.spotSorting = Sorting(rawValue: spotSorting) ?? .Name
        self.shouldDisplayCapacityLabel = shouldDisplayCapacityLabel
    }
    
    init(poolSorting: Sorting, spotSorting: Sorting, shouldDisplayCapacityLabel: Bool) {
        self.poolSorting = poolSorting
        self.spotSorting = spotSorting
        self.shouldDisplayCapacityLabel = shouldDisplayCapacityLabel
    }
}
