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

    @State var date: Timestamp
    @State var items: [InventoryCountMapping]

    var body: some View {
        NavigationStack {
            
            SearchBarView(text: $viewModel.searchText)
            
            List {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    let filteredItemsForType = filteredItems(for: itemType)
                    
                    if !filteredItemsForType.isEmpty {
                        Section(header: Text(itemType.rawValue)) {
                            ForEach(filteredItemsForType.sorted(by: { (item1, item2) in
                                if let name1 = viewModel.dbItems.first(where: { $0.id == item1.itemID })?.name,
                                   let name2 = viewModel.dbItems.first(where: { $0.id == item2.itemID })?.name {
                                    return name1 < name2
                                }
                                return false
                            }), id: \.self) { item in
                                HStack {
                                    if let itemName = viewModel.dbItems.first(where: { $0.id == item.itemID })?.name {
                                        Text("\(itemName)")
                                    }

                                    Spacer()

                                    Text("\(item.itemCount)")
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                }
                            }

                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchItems()
            }
        }
    }

    func removePunctuation(from text: String) -> String {
        let punctuationSet = CharacterSet.punctuationCharacters
        let filteredText = text.components(separatedBy: punctuationSet).joined(separator: "")
        return filteredText
    }

    func filteredItems(for itemType: ItemType) -> [InventoryCountMapping] {
        let searchTextWithoutPunctuation = removePunctuation(from: viewModel.searchText.lowercased())
        
        return items.filter { item in
            if let itemObj = viewModel.dbItems.first(where: { $0.id == item.itemID }) {
                let itemNameWithoutPunctuation = removePunctuation(from: itemObj.name.lowercased())
                
                let itemNameMatches = itemNameWithoutPunctuation.contains(searchTextWithoutPunctuation)
                let itemTypeMatches = itemObj.type == itemType
                
                return viewModel.searchText.isEmpty ? itemTypeMatches : (itemNameMatches && itemTypeMatches)
            }
            return false
        }
    }

    
}
