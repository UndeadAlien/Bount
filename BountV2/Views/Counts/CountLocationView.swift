//
//  CountLocationView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/2/24.
//

import SwiftUI
import FirebaseFirestore

struct CountLocationView: View {
    @ObservedObject var viewModel: CountVM
    
    var items: [Item]
    var locations: [Location]
    var date: Date
    var counts: [LocationCount]
    
    var body: some View {
        List {
            ForEach(counts, id: \.self) { count in
                NavigationLink(destination: CountDetailView(
                    viewModel: viewModel,
                    items: items,
                    count: count,
                    locationName: viewModel.getLocationName(locations: locations, by: count.locationID)
                )) {
                    VStack(alignment: .leading) {
                        Text("\(viewModel.getLocationName(locations: locations, by: count.locationID))")
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CountLocationView(
            viewModel: CountVM(),
            items: Item.testItems,
            locations: Location.testLocations,
            date: Date(),
            counts: LocationCount.testLocationCounts
        )
        .preferredColorScheme(.dark)
    }
}
