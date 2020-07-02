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
    
    @Published var pools = [Pool]()
    
    public var location: CLLocation? {
        self.locationManager.userLocation
    }

    public var locationIsAvailable: Bool {
        self.locationManager.locationIsAvailable
    }
    
    init() {
        self.networkManager.getAllPools(completion: self.getPoolData(_:))
    }
    
    func getPoolData(_ response:PoolResponse) {
        DispatchQueue.main.async {
            self.pools = response.features
            self.sortPools(sorting: .Name)
        }
    }
    
    public func sortPools(sorting: Sorting) {
        switch sorting {
        case .Favorites:
            print("Not yet implemented!")
        case .Vicinity:
            print("Not yet implemented!")
        case .Capacity:
            self.pools.sort(by: { pool1, pool2 in
                let cap1 = pool1.properties.auslastungAmpelKategorie0
                let cap2 = pool2.properties.auslastungAmpelKategorie0
                
                if cap1 > 0 && cap2 <= 0 {
                    return true
                }
                if cap1 <= 0 && cap2 > 0 {
                    return false
                }
                return cap1 < cap2
            })
        case .Name:
            self.pools.sort(by: {p1, p2 in
                p1.properties.name < p2.properties.name
            })
        }
    }
}

public enum Sorting {
    case Favorites;
    case Vicinity;
    case Capacity;
    case Name;
}
