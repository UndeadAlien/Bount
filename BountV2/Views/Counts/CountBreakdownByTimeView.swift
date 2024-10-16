//
//  CountBreakdownByTimeView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/2/24.
//

import SwiftUI
import FirebaseFirestore

struct CountBreakdownByTimeView: View {
    @ObservedObject var viewModel: CountVM

    var items: [Item]
    var vendors: [Vendor]
    var locations: [Location]
    var date: Date
    var counts: [LocationCount]
    var countsByTime: [String: [LocationCount]] {
        Dictionary(grouping: counts) { count in
            viewModel.formatTime(date: count.timestamp?.dateValue() ?? Date())
        }
    }

    var body: some View {
        List {
            ForEach(countsByTime.keys.sorted(), id: \.self) { time in
                let matchingCounts = countsByTime[time] ?? []
                
                DisclosureGroup {
                    NavigationLink(destination: CombinedCountDetailView(
                        viewModel: viewModel,
                        items: items,
                        counts: matchingCounts, 
                        vendors: vendors
                    )) {
                        Text("Full Count")
                            .foregroundStyle(Color("Green2"))
                            .modifier(FontMod(size: 16, isBold: true))
                    }
                    
                    ForEach(matchingCounts, id: \.self) { count in
                        NavigationLink(destination: CountDetailView(
                            viewModel: viewModel,
                            items: items,
                            count: count,
                            locationName: viewModel.getLocationName(locations: locations, by: count.locationID)
                        )) {
                            Text("\(viewModel.getLocationName(locations: locations, by: count.locationID))")
                                .modifier(FontMod(size: 16, isBold: true))
                        }
                        .padding(.leading, 10)
                    }
                } label: {
                    Text("\(time)")
                        .foregroundStyle(Color("Green1"))
                        .modifier(FontMod(size: 16, isBold: true))
                }
                .padding(.vertical, 5)
            }
        }
        .navigationTitle("\(viewModel.formatDate(date: date))")
    }
}

#Preview {
    NavigationStack {
        CountBreakdownByTimeView(
            viewModel: CountVM(),
            items: Item.testItems,
            vendors: Vendor.testVendors,
            locations: Location.testLocations,
            date: Date(),
            counts: LocationCount.testLocationCounts
        )
        .preferredColorScheme(.dark)
    }
}

