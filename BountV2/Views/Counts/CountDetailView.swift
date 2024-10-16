//
//  CountDetailView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/1/24.
//

import SwiftUI

struct CountDetailView: View {
    @ObservedObject var viewModel: CountVM
    var items: [Item]
    var count: LocationCount
    var locationName: String
    
    var filteredItems: [ItemCountMapping] {
        if viewModel.searchText.isEmpty {
            return count.itemCountMapping
        } else {
            return count.itemCountMapping.filter { item in
                let itemName = viewModel.getItemName(items: items, by: item.itemID)
                return itemName.localizedCaseInsensitiveContains(viewModel.searchText)
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            List {
                ForEach(filteredItems, id: \.itemID) { item in
                    Text("\(viewModel.getItemName(items: items, by: item.itemID))")
                        .badge("\(item.itemCount)")
                        .modifier(FontMod(size: 16, isBold: true))
                }
            }
            .listStyle(InsetListStyle())
            .searchable(text: $viewModel.searchText)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Text("\(locationName)")
                    .modifier(FontMod(size: 18, isBold: true))
            }
        }
    }
}

#Preview {
    NavigationStack {
        CountDetailView(
            viewModel: CountVM(),
            items: Item.testItems,
            count: LocationCount.testLocationCounts[1],
            locationName: "Location A"
        )
        .preferredColorScheme(.dark)
    }
}
