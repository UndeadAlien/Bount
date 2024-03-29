//
//  InlineHeaderView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/14/24.
//

import SwiftUI

struct InlineHeaderView<Content: View>: View {
    
    var title: String?
    var content: (() -> Content)?
    
    var body: some View {
        Rectangle()
            .frame(height: 0)
            .background(Color("primaryColor"))
            .navigationTitle(title ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
        if let content = content {
            content()
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 500, height: 500)) {
    InlineHeaderView(title: "Header Name") {
        VStack{
            Text("hi")
        }
    }
        .preferredColorScheme(.dark)
}
