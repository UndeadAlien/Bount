//
//  LocationView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct LocationView: View {
    @FirestoreQuery(collectionPath: "locations") private var locations: [Location]
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            List(locations.sorted(by: {$0.name < $1.name}), id: \.self) { location in
                NavigationLink(destination: LocationDetailView(location: location)) {
                    Text(location.name)
                        .modifier(FontMod(size: 18, isBold: true))
                        .foregroundStyle(Color.purple)
                }
                .modifier(NavLinkMod())
            }
            .listStyle(InsetListStyle())
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    LocationView()
        .preferredColorScheme(.dark)
}
