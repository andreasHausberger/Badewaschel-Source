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
    
    func getDate(originalDate: String) -> String? {
          let input = originalDate
          let formatter = DateFormatter()
          formatter.locale = Locale(identifier: "de")
          formatter.dateFormat = "yyyy-MM-dd'Z'"
          if let date = formatter.date(from: input) {
              
              var dayComponent    = DateComponents()
              dayComponent.day = 1 // For removing one day (yesterday): -1
              let currentcalendar = Calendar.current
              let datePlusOneDay  = currentcalendar.date(byAdding: dayComponent, to: date)
              
              let outputFormatter = DateFormatter()
              outputFormatter.dateFormat = "EEEE, d. MMMM, yyyy"
              outputFormatter.locale = Locale(identifier: "de_AT")
              return(outputFormatter.string(from: datePlusOneDay ?? Date()))
          }
          return nil
      }

}
