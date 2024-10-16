//
//  FontMod.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/14/24.
//

import SwiftUI

struct FontMod: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    var size: CGFloat
    var isBold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom("ArialRoundedMTBold", size: size))
            .fontWeight(isBold ? .black : .regular)
            .fontDesign(.rounded)
            .padding(.vertical, 8)
            .foregroundStyle(colorScheme == .dark ? .white : .black)
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 500, height: 75)) {
    List {
        Text("Alien")
            .modifier(FontMod(size: 16, isBold: true))
        Text("Raccoon")
            .modifier(FontMod(size: 16, isBold: true))
    }
}
