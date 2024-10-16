//
//  Extension+View.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/1/24.
//

import SwiftUI

extension View {
    func stepperStyle(fontSize: CGFloat) -> some View {
        self
            .font(.system(size: fontSize, weight: .bold))
            .frame(minWidth: 60, minHeight: 35, alignment: .center)
            .modifier(GlassyBackgroundModifier())
            .cornerRadius(10)
    }
}
