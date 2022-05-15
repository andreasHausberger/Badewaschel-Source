//
//  NetworkManager.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import Flyweight

class NetworkManager {
    
    private static var sharedManager = NetworkManager()
    private var data: PoolResponse?
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var poolApiURL = Constants.poolURL
    private var spotApiURL = Constants.spotURL
    private var federalSpotApiURL = Constants.federalSpotURL
    
    public static func shared() -> NetworkManager {
        return NetworkManager.sharedManager
    }
    
    /**
       Get all Pool objects.

       - parameter completion: Function that takes a response object. Should be supplied by Model class.
    */
    public func getAllPools(completion: @escaping (PoolResponse) -> ()) {
        self.getDataFromUrl(url: self.poolApiURL,completion: completion)
    }
    
    /**
    Get all Spot objects.

    - parameter completion: Function that takes a response object. Should be supplied by Model class.
    */
    public func getAllSpots(completion: @escaping (SpotResponse) -> ()) {
        self.getDataFromUrl(url: self.spotApiURL, completion: completion)
    }
    
    public func getFederalSpots() async -> FederalSpotResponse? {
        await self.getData(from: self.federalSpotApiURL)
    }
    
    /**
    Gets JSON data from supplied URL. Completion on success.

    - parameter url: URL String of API Url.
    - parameter completion: Function that takes a response object. Should be supplied by Model class.
    - warning: Response Object confirms to Response protocol. May cause errors otherwise.
    */
    private func getDataFromUrl<ResponseObject: Codable> (url: String, completion: @escaping (ResponseObject) -> ()) {
//        dataTask?.cancel()
        
        guard let url = URL(string: url) else { return }
        
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            }
            
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                do {
                    let responseData = try JSONDecoder().decode(ResponseObject.self, from: data)
                    completion(responseData)
                }
                catch let error {
                    print("Error: \(error)")
                    return
                }
            }
        }
        dataTask?.resume()
    }
    
    private func getData<ResponseObject: Codable>(from url: String) async -> ResponseObject? {
        guard let url = URL(string: url) else { return nil }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let response = response as? HTTPURLResponse {
                guard response.statusCode == 200 else { throw NSError(domain: "network", code: response.statusCode) }
            }
            return try JSONDecoder().decode(ResponseObject.self, from: data)
            
        } catch let error {
            print("Error: \(error)")
            return nil
        }
    }
}
