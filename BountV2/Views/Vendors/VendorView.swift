//
//  VendorListView.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct VendorView: View {
    
    @FirestoreQuery(collectionPath: "vendors") private var vendors: [Vendor]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            InlineHeaderView(title: "Vendors") {
                List(vendors, id: \.self) { vendor in
                    VStack {
                        NavigationLink(destination: VendorDetailView(vendor: vendor)) {
                            Text(vendor.name)
                                .modifier(FontMod(size: 18, isBold: true))
                                .foregroundStyle(Color.purple)
//                                .foregroundColor(colorScheme == .dark ? .white : .black)
//                                .padding(.vertical, 10)
                        }
//                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
                .listStyle(InsetListStyle())
            }
        }
    }
}

#Preview {
    VendorView()
        .preferredColorScheme(.dark)
}
