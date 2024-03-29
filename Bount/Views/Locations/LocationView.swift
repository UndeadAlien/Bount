//
//  LocationView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct LocationView: View {
    
    // display all locations
    // display location name at the top
    
    @FirestoreQuery(collectionPath: "locations") private var locations: [Location]
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                List(locations, id: \.self) { location in
                    VStack {
                        NavigationLink(destination: LocationDetailView(location: location)) {
                            Text(location.name)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    LocationView()
}
