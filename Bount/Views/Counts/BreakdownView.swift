//
//  CountHistoryBreakdownView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BreakdownView: View {

    @StateObject var viewModel = BreakdownVM()
    
    @State var items: [InventoryCountMapping]
    
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    
    var filterByVendor: [Vendor] {
        guard !viewModel.searchText.isEmpty else { return vendors }
        
        let searchTextWithoutPunctuation = viewModel.removePunctuation(from: viewModel.searchText.lowercased())
        return vendors.filter { vendor in
            let vendorNameWithoutPunctuation = viewModel.removePunctuation(from: vendor.name.lowercased())
            return vendorNameWithoutPunctuation.contains(searchTextWithoutPunctuation)
        }
    }

    var body: some View {
        NavigationStack {
            InlineHeaderView() {
                inventoryCountList()
                    .onAppear {
                        viewModel.fetchItems()
                    }
                    .searchable(text: $viewModel.searchText)
                    .listStyle(InsetListStyle())
            }
        }
    }
    
    @ViewBuilder
    func inventoryCountList() -> some View {
        List {
            ForEach(filterByVendor, id: \.self) { vendor in
                NavigationLink(destination: VendorCountView(
                    vendor: vendor,
                    filteredItems: filteredItems(for: vendor),
                    viewModel: viewModel)
                ) {
                    Text(vendor.name)
                        .foregroundStyle(Color.purple)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }
            
            NavigationLink(destination: VendorCountView(
                vendor: nil,
                filteredItems: itemsWithNoVendor(),
                viewModel: viewModel)
            ) {
                Text("No Vendor")
                    .foregroundStyle(Color.red)
                    .modifier(FontMod(size: 18, isBold: true))
            }
        }
    }
    
    func filteredItems(for vendor: Vendor) -> [InventoryCountMapping] {
        let filteredItems = items.filter { item in
            return vendor.inventory.contains(item.itemID)
        }

        return filteredItems
    }

    func itemsWithNoVendor() -> [InventoryCountMapping] {
        let vendorItemIDs = vendors.flatMap { $0.inventory }
        let itemsWithNoVendor = items.filter { item in
            return !vendorItemIDs.contains(item.itemID)
        }

        return itemsWithNoVendor
    }
}

struct VendorCountView: View {
    let vendor: Vendor?
    let filteredItems: [InventoryCountMapping]
    @ObservedObject var viewModel: BreakdownVM

    var body: some View {
        List {
            Section(header:
                        Text(vendor?.name ?? "No Vendor")
                            .foregroundStyle(vendor?.name != nil ? Color.purple: Color.red)
                            .modifier(FontMod(size: 18, isBold: true))
            ) {
                ForEach(viewModel.sortItems(mapping: filteredItems), id: \.self) { item in
                    if let itemName = viewModel.dbItems.first(where: { $0.id == item.itemID })?.name {
                        Text("\(itemName)")
                            .badge(item.itemCount)
                            .modifier(FontMod(size: 14, isBold: false))
                    }
                }
            }
        }
    }
}

