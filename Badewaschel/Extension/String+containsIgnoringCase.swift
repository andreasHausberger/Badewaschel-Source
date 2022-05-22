//
//  String+containsIgnoringCase.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 22.05.22.
//  Copyright © 2022 Andreas Hausberger. All rights reserved.
//

import Foundation

extension String {
    func containsIgnoringCase(_ text: String) -> Bool {
        return self.uppercased().contains(text.uppercased())
    }
}
