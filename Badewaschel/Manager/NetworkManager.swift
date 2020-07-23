//
//  NetworkManager.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 26.06.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation

class NetworkManager {
    
    private static var sharedManager = NetworkManager()
    
    private var data: PoolResponse?
    
    private let defaultSession = URLSession(configuration: .default)
    
    private var dataTask: URLSessionDataTask?
    
    private var poolApiURL = Constants.poolURL
    
    private var components = "service=WFS&request=GetFeature&version=1.1.0&typeName=ogdwien:SCHWIMMBADOGD&srsName=EPSG:4326&outputFormat=json"
    
    
    public static func shared() -> NetworkManager {
        return NetworkManager.sharedManager
    }
    
    public func getAllPools(completion: @escaping (PoolResponse) -> ()) {
        self.getDataFromUrl(url: self.poolApiURL,completion: completion)
    }
    
    private func getDataFromUrl<ResponseObject: Response>(url: String, completion: @escaping (ResponseObject) -> ()) {
        dataTask?.cancel()
        
        
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
    
    private func decodeData(_ data: Data) -> [Pool]? {
        do {
            let poolData = try JSONDecoder().decode(PoolResponse.self, from: data)
            return poolData.features
        }
        catch let error {
            print("Error \(error)")
        }
        return nil
    }
    
    private func updatePoolData(_ data: Data) {
        do {
            self.data =  try JSONDecoder().decode(PoolResponse.self, from: data)
            if self.data != nil {
                print("Decoded Data for \(self.data!.features.count) items")
            }
        }
        catch let error {
            print("Error: \(error)")
        }
    }
}
