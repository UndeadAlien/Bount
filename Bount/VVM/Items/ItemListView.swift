//
//  ItemListView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/20/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ItemListView: View {
    @StateObject var viewModel = ItemListVM()
    
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    var body: some View {

        NavigationStack {
            List {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    Section(header: Text(itemType.rawValue)) {
                        ForEach(filteredItems(for: itemType), id: \.self) { item in
                            NavigationLink(destination: ItemView(item: item)) {
                                Text("\(item.name)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddItemView()) {
                        Label("", systemImage: "plus")
                    }
                }
            }
        }
    }

    func filteredItems(for itemType: ItemType) -> [Item] {
        return items.filter { item in
            return item.type.rawValue == itemType.rawValue
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
