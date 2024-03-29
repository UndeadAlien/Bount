//
//  Gradients.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/14/24.
//

import SwiftUI

struct Gradients: View {
    
    let colors = [Color("Purple1"), Color("Purple2")]
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
            .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    Gradients()
}
