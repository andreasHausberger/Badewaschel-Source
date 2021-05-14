//
//  Color+getColorForCapacity.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 14.05.21.
//  Copyright © 2021 Andreas Hausberger. All rights reserved.
//

import SwiftUI

extension Color {
    static func getColorForCapacity(capacity: Int) -> Color {
        switch capacity {
        case 0:
            return .gray
        case 1:
            return .green
        case 2:
            return Color("LightGreen")
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
