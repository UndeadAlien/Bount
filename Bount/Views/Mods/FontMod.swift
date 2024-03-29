//
//  FontMod.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/14/24.
//

import SwiftUI

struct FontMod: ViewModifier {
    
    var size: CGFloat
    var isBold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom("ArialRoundedMTBold", size: size))
            .fontWeight(isBold ? .black : .regular)
            .fontDesign(.rounded)
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 500, height: 75)) {
    Group {
        Text("The quick brown fox jumps over the lazy dog")
            .modifier(FontMod(size: 24, isBold: false))
        Spacer()
        Text("The quick brown fox jumps over the lazy dog")
            .modifier(FontMod(size: 18, isBold: true))
    }
}
