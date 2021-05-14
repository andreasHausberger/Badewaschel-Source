//
//  ColorExtension.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 05.07.20.
//  Copyright © 2020 Andreas Hausberger. All rights reserved.
//

import Foundation
import SwiftUI

extension UIColor {
    
    static func getColorForCapacity(capacity: Int) -> UIColor {
        switch capacity {
        case 0:
            return .gray
        case 1:
            return .green
        case 2:
            return UIColor(named: "LightGreen")!
        case 3:
            return .yellow
        case 4:
            return .orange
        case 5:
            return .red
        default:
            return .gray
        }
    }
}
