//
//  Date+dateFromString.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 13.05.21.
//  Copyright © 2021 Andreas Hausberger. All rights reserved.
//

import Foundation

extension Date {
    static func dateFromString(dateString: String, formatString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = formatString
        return formatter.date(from: dateString)
    }
}
