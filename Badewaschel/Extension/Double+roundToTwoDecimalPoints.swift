//
//  Double+roundToTwoDecimalPoints.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 22.05.22.
//  Copyright © 2022 Andreas Hausberger. All rights reserved.
//

import Foundation

extension Double {
    func roundToTwoDecimalPoints() -> String {
        return String(format: "%.3f", self)
    }
}
