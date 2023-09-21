//
//  ItemSelectionView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/20/23.
//

import SwiftUI

struct ItemSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedItems: Set<Item>
    let items: [Item]
    
    @State var searchText = ""
    
    var filteredItems: [Item] {
        let searchText = searchText.lowercased()
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                let itemName = item.name.lowercased()
                let itemType = item.type.rawValue.lowercased()
                return itemName.contains(searchText) || itemType.contains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            
            SearchBarView(text: $searchText)
            Form {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    let itemsForType = filteredItemsForType(itemType)
                    if !itemsForType.isEmpty {
                        Section(header: Text(itemType.rawValue)) {
                            ForEach(itemsForType, id: \.self) { item in
                                MultipleSelectionRow(
                                    title: item.name,
                                    isSelected: Binding(
                                        get: { self.selectedItems.contains(item) },
                                        set: { newValue in
                                            if newValue {
                                                self.selectedItems.insert(item)
                                            } else {
                                                self.selectedItems.remove(item)
                                            }
                                        }
                                    )
                                )
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Select Items")
            .navigationBarItems(
                trailing: Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    func filteredItemsForType(_ itemType: ItemType) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Binding<Bool>

    var body: some View {
        Toggle(isOn: isSelected) {
            Text(title)
        }
    }
}

struct ItemSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let items: [Item] = [
            Item(name: "Item 1", type: .VODKA),
            Item(name: "Item 2", type: .BEER),
            Item(name: "Item 3", type: .TEQUILA)
        ]
        let selectedItems = Binding<Set<Item>>(
            get: { Set(items.prefix(2)) },
            set: { _ in }
        )
        
        return ItemSelectionView(selectedItems: selectedItems, items: items)
    }
}

