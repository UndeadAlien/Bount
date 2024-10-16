//
//  NavLinkMod.swift
//  Bount
//
//  Created by Connor Hutchinson on 7/1/24.
//

import SwiftUI

struct NavLinkMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowSeparatorTint(.purple.opacity(0.5))
    }
}

#Preview {
    List{
        Text("AAA")
        Text("BBB")
        Text("CCC")
    }
    .modifier(NavLinkMod())
}
