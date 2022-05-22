//
//  SpotModel.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 23.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import MapKit
import Combine
import Flyweight

class SpotModel: ObservableObject {
    
    var subs: Set<AnyCancellable> = []
    public var sorting: Sorting = .Name
    private let networkManager = NetworkManager.shared()
    private let dataManager = DataManager()
    private let locationManager = LocationManager()
    
    @Published var spots = [Spot]()
    @Published var federalStates = [FederalState]()
    @Published var allStates = [FederalState]()
    @Published var favorites = [String]()
    @Published var options: UserOptions?
    
    @Published var currentFilter: String?
    @Published var currentSearchText: String = ""
    
    init() {
        DispatchQueue.main.async {
             self.networkManager.getAllSpots(completion: self.getSpotData(_:))
        }
        Task {
            let federalSpotResponse = await self.getFederalSpotData()
            DispatchQueue.main.async {
                self.federalStates = federalSpotResponse?.states ?? []
                self.allStates = federalSpotResponse?.states ?? []
            }
        }
        
        $currentFilter
            .receive(on: DispatchQueue.main)
            .sink { filter in
                self.federalStates = self.allStates
                if let filter = filter,
                   !filter.isEmpty {
                    self.federalStates = self.federalStates.filter { $0.stateName == filter }
                }
            }
            .store(in: &subs)
        
        $currentSearchText
            .receive(on: DispatchQueue.main)
            .sink { text in
                self.federalStates = self.allStates
                if !text.isEmpty {
                    self.federalStates = self.federalStates
                        .map { state in
                            let filteredSpots = state.spots.filter { $0.badegewaessername.containsIgnoringCase(text) || $0.plzOrt.containsIgnoringCase(text) }
                            return FederalState(stateName: state.stateName, spots: filteredSpots)
                        }
                        .filter { !$0.spots.isEmpty }
                } else {
                    self.applyStateFilter(stateName: self.currentFilter)
                }
            }
            .store(in: &subs)
    }
    
    //MARK: Data
    func getSpotData(_ response: SpotResponse) {
        DispatchQueue.main.async {
            self.spots = response.features
        }
    }
    
    func reloadFederalSpotData() {
        Task {
            let response = await self.getFederalSpotData()
            DispatchQueue.main.async {
                self.allStates = response?.states ?? []
                self.federalStates = response?.states ?? []
            }
        }
    }
    
    private func getFederalSpotData() async -> FederalSpotResponse? {
        return await self.networkManager.getFederalSpots()
    }
    
    func loadSpots() {
        do {
            let publisher: AnyPublisher<SpotResponse, APIError> = try Network.get(urlString: Constants.spotURL)
            publisher
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }, receiveValue: { response in
                    DispatchQueue.main.async {
                        self.getOptions()
                        self.spots = response.features
                        self.favorites = self.getFavorites().compactMap { $0.id }
                        self.sortSpots(sorting: self.options?.spotSorting ?? Sorting.Name)
                    }
                })
                .store(in: &subs)
        }
        catch let error {
            print("error: \(error)")
        }
    }
    
    func getSpotPublisher() -> AnyPublisher<[Spot], APIError>? {
        do {
            let publisher: AnyPublisher<SpotResponse, APIError> = try Network.get(urlString: Constants.spotURL)
            
            return publisher
                .compactMap { $0.features }
                .eraseToAnyPublisher()
        }
        catch let error {
            print("error: \(error)")
        }
        return nil
    }
    
    func manuallyRefreshSpots(completion: @escaping () -> ()) {
        Task {
            await self.getFederalSpotData()
        }
        completion()
    }
    
    //MARK: Favorites
    
    public func getFavorites() -> [Spot] {
        let favoriteIds = self.dataManager.getFavoriteIDs()
        let filteredSpots = self.spots.filter( { favoriteIds.contains($0.id) })
        return filteredSpots
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
    
    //MARK: Sorting
    
    public func sortSpots(sorting: Sorting) {
        self.sorting = sorting
        switch sorting {
        case .Name:
            self.federalStates = self.federalStates
                .sorted {
                    $0.stateName < $1.stateName
                }
                .map { state in
                    FederalState(stateName: state.stateName, spots: state.spots.sorted { $0.badegewaessername < $1.badegewaessername } )
                }
            print("Name Sort")
        case .Vicinity:
            self.federalStates = self.federalStates
                .map { state in
                    FederalState(stateName: state.stateName, spots: state.spots.sorted(by: sortSpotsByVicinity(spot1:spot2:)))
                }
        case .Favorites:
            self.federalStates = self.federalStates
                .map { state in
                    FederalState(stateName: state.stateName, spots: state.spots.sorted(by: sortSpotsByFavorites(spot1:spot2:)))
                }
        default:
            print("default")
        }
    }
    
    private func sortSpotsByFavorites(spot1: FederalSpot, spot2: FederalSpot) -> Bool {
        let spot1isFavorite = self.favorites.contains(spot1.badegewaesserid)
        let spot2isFavorite = self.favorites.contains(spot2.badegewaesserid)
        
        if spot1isFavorite && !spot2isFavorite { return true }
        if !spot1isFavorite && spot2isFavorite { return false }
        
        return spot1.badegewaessername < spot2.badegewaessername
    }
    
    private func sortSpotsByVicinity(spot1: FederalSpot, spot2: FederalSpot) -> Bool {
        if let userLocation = locationManager.userLocation {
            let latLon1 = spot1.getLatLon()
            let latLon2 = spot2.getLatLon()
            let location1 = CLLocation(latitude: latLon1.lat, longitude: latLon1.lon)
            let location2 = CLLocation(latitude: latLon2.lat, longitude: latLon2.lon)
            
            let distance1 = userLocation.distance(from: location1)
            let distance2 = userLocation.distance(from: location2)
            
            return distance1 < distance2
        }
        return false
    }
    
    // MARK: - Filter
    
    public func applyStateFilter(stateName: String?) {
        self.currentFilter = stateName
    }
    
    // MARK: - Options
    
    public func getOptions() {
        self.options = self.dataManager.getUserOptions()
        
    }
    
    public func updateOptions() {
        if let sorting = self.options?.spotSorting {
            self.sorting = sorting
        }
    }
}
