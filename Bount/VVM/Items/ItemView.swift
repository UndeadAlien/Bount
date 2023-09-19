//
//  ItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ItemView: View {
    @StateObject var viewModel = ItemVM()
    
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    var body: some View {

        NavigationStack {
            List {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    Section(header: Text(itemType.rawValue)) {
                        ForEach(filteredItems(for: itemType), id: \.self) { item in
                            HStack {
                                Text("\(item.name)")
                                Spacer()
                                Text("\(item.type.rawValue)")
                                Spacer()
                                Text("\(item.price ?? -1)")
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

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
