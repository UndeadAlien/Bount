//
//  CombinedCountDetailView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/2/24.
//

import SwiftUI
import FirebaseFirestore

struct CombinedCountDetailView: View {
    @ObservedObject var viewModel: CountVM
    var items: [Item]
    var counts: [LocationCount]
    var vendors: [Vendor]

    var groupedAndCombinedCounts: [(timestamp: Date, combinedItems: [ItemCountMapping])] {
        let groupedCounts = Dictionary(grouping: counts) { count in
            viewModel.normalizeDate(count.timestamp?.dateValue() ?? Date())
        }
        
        return groupedCounts.map { (timestamp, counts) in
            let itemCounts = counts.flatMap { $0.itemCountMapping }
                .reduce(into: [String: Int]()) { result, itemMapping in
                    result[itemMapping.itemID, default: 0] += itemMapping.itemCount
                }

            let combinedItemMappings = itemCounts.map { ItemCountMapping(itemID: $0.key, itemCount: $0.value) }
            
            return (timestamp: timestamp, combinedItems: combinedItemMappings)
        }
        .sorted { $0.timestamp < $1.timestamp }
    }
    
    var filteredVendors: [Vendor] {
        guard !viewModel.searchText.isEmpty else { return vendors }
        
        let searchTextWithoutPunctuation = viewModel.removePunctuation(from: viewModel.searchText.lowercased())
        
        return vendors.filter { vendor in
            let vendorNameWithoutPunctuation = viewModel.removePunctuation(from: vendor.name.lowercased())
            let vendorMatchesName = vendorNameWithoutPunctuation.contains(searchTextWithoutPunctuation)
            
            let vendorMatchesItems = items.contains { item in
                let itemNameWithoutPunctuation = viewModel.removePunctuation(from: item.name.lowercased())
                return vendor.inventory.contains(item.id ?? "") && itemNameWithoutPunctuation.contains(searchTextWithoutPunctuation)
            }
            
            return vendorMatchesName || vendorMatchesItems
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            List {
                ForEach(filteredVendors, id: \.id) { vendor in
                    vendorDisclosureGroup(for: vendor)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $viewModel.searchText)
        }
    }

    private func vendorDisclosureGroup(for vendor: Vendor) -> some View {
        DisclosureGroup {
            ForEach(groupedAndCombinedCounts, id: \.timestamp) { group in
                filteredItems(for: group, vendor: vendor)
            }
        } label: {
            Text(vendor.name)
                .foregroundStyle(.purple)
                .modifier(FontMod(size: 18, isBold: true))
        }
    }

    private func filteredItems(for group: (timestamp: Date, combinedItems: [ItemCountMapping]), vendor: Vendor) -> some View {
        
        let filteredGroup = group.combinedItems.filter { combinedItem in
            vendor.inventory.contains(combinedItem.itemID)
        }

        let sortedGroup = filteredGroup.sorted { item1, item2 in
            viewModel.getItemName(items: items, by: item1.itemID) < viewModel.getItemName(items: items, by: item2.itemID)
        }

        return ForEach(sortedGroup, id: \.itemID) { item in
            Text("\(viewModel.getItemName(items: items, by: item.itemID))")
                .badge("\(item.itemCount)")
                .modifier(FontMod(size: 16, isBold: true))
        }
    }
}

#Preview {
    CombinedCountDetailView(
        viewModel: CountVM(),
        items: Item.testItems,
        counts: LocationCount.testLocationCounts,
        vendors: Vendor.testVendors
    )
    .preferredColorScheme(.dark)
}
