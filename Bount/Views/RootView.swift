//
//  RootView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        VStack {
            CustomTabBar()
        }
    }
}

#Preview {
    RootView()
        .preferredColorScheme(.dark)
}
