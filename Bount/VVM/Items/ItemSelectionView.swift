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
    
    var body: some View {
        NavigationView {
            List(items, id: \.self) { item in
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
            .navigationBarTitle("Select Items")
            .navigationBarItems(
                trailing: Button("Done") {
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
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

