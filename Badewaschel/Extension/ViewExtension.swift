//
//  ViewExtension.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 03.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import SwiftUI


extension View {
    
    public var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    func openLink(link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else {
            print("No link")
        }
    }
    
    func createMapsUrl(for pool: Pool?) -> String {
        let address = pool?.properties.adresse
        let uriEncodedAddress = address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mapsLink = "http://maps.apple.com/" + "?address=" + (uriEncodedAddress ?? "")
        return mapsLink
    }

}
