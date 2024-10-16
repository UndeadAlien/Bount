//
//  LabelMod.swift
//  Bount
//
//  Created by Connor Hutchinson on 6/30/24.
//

import SwiftUI

struct LabelMod: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .font(.custom("ArialRoundedMTBold", size: 14))
            .fontWeight(.black)
            .fontDesign(.rounded)
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .padding(.vertical, 10)
    }
}

#Preview {
    

    return Text("Sample Text")
            .preferredColorScheme(.dark)
        
}
