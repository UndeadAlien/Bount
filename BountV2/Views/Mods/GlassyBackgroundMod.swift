//
//  GlassyBackgroundMod.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/1/24.
//

import SwiftUI

struct GlassyBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.2))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                            .blur(radius: 10)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
                    .shadow(color: .white.opacity(0.7), radius: 1, x: 0, y: 1)
            )
    }
}
