//
//  ErrorViewModifier.swift
//  Badewaschel
//
//  Created by Andreas Hausberger on 15.05.22.
//  Copyright © 2022 Andreas Hausberger. All rights reserved.
//

import Foundation
import SwiftUI

struct ErrorView: ViewModifier {
    func body(content: Content) -> some View {
        VStack(alignment: .center) {
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Divider()
                content
            }
            .padding(10)
        }
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(25)
    }
}
