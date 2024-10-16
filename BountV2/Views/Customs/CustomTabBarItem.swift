//
//  CustomTabBarItem.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import SwiftUI

struct CustomTabBarItem: View {
    
    var buttonIcon: String
    var buttonText: String
    var isActive: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 4) {
                if isActive {
                    Rectangle()
                        .foregroundColor(.purple)
                        .frame(width: geo.size.width / 3, height: 4)
                }
                
                Image(systemName: buttonIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .font(.custom("ArialRoundedMTBold", size: 10))
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                Text(buttonText)
                    .font(.custom("ArialRoundedMTBold", size: 10))
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                    .textCase(.uppercase)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .offset(y: isActive ? 0 : 4)
        }
    }
}

#Preview {
    Group {
        CustomTabBarItem(buttonIcon: "person", buttonText: "Testing", isActive: true)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("1")
    }
    .preferredColorScheme(.dark)
}

