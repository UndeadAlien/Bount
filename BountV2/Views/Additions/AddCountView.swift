//  CustomCountView.swift
//  Bount
//
//  Created by Connor Hutchinson on 6/19/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct AddCountView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: CountVM
    
    var location: Location
    var items: [Item]
    
    var filteredItems: [Item] {
        let searchText = viewModel.searchText.lowercased()
        return searchText.isEmpty ? items : items.filter { item in
            item.name.lowercased().contains(searchText) || item.type.rawValue.lowercased().contains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                    let itemsForType = filteredItemsForType(itemType)
                    if !itemsForType.isEmpty {
                        Section(header: Text(itemType.rawValue)
                            .foregroundStyle(.purple)
                            .modifier(FontMod(size: 18, isBold: true))
                        ) {
                            ForEach(itemsForType.sorted(by: { $0.name < $1.name }), id: \.id) { item in
                                itemRow(for: item)
                            }
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .searchable(text: $viewModel.searchText)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .listStyle(InsetListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { backButton }
                ToolbarItem(placement: .navigationBarTrailing) { saveButton }
                ToolbarItem(placement: .bottomBar) {
                    Text(location.name).font(.title2).bold()
                }
            }
        }
    }
    
    private func itemRow(for item: Item) -> some View {
        return HStack {
            Text(item.name)
                .modifier(FontMod(size: 16, isBold: true))

            Spacer()

            Stepper(
                value: Binding(
                    get: { viewModel.getItemCount(for: location.id!, item.id!) },
                    set: { newValue in
                        viewModel.setItemCount(for: location.id!, item.id!, count: newValue)
                    }
                ), in: 0...Int.max,
                label: {
                    Text("\(viewModel.getItemCount(for: location.id!, item.id!))")
                        .stepperStyle(fontSize: 18)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                }
            )


        }
    }
    
    private func sectionHeader(for itemType: ItemType) -> some View {
        Text(itemType.rawValue)
            .foregroundStyle(.purple)
            .modifier(FontMod(size: 18, isBold: true))
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Locations")
            }
            .foregroundStyle(Color.red)
            .modifier(FontMod(size: 18, isBold: true))
        }
    }
    
    private var saveButton: some View {
        Button {
            viewModel.submittedLocations.append(location)
            dismiss()
        } label: {
            Text("Save")
                .foregroundStyle(Color("Green1"))
                .modifier(FontMod(size: 18, isBold: true))
        }
    }
    
    private func itemsByType(_ itemType: ItemType) -> [Item] {
        filteredItems.filter { $0.type == itemType }
    }
    
    func filteredItemsForType(_ itemType: ItemType) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}

#Preview {
    AddCountView(
        viewModel: CountVM(),
        location: Location(id: "15Q0BsporYNSlvwHIe6O", name: "Bob's Shop"),
        items: [
            Item(id: UUID().uuidString, name: "Test Beer", type: .BEER),
            Item(id: UUID().uuidString, name: "Test Liqueur", type: .LIQUEUR),
            Item(id: UUID().uuidString, name: "Test Wine", type: .WINE)
        ]
    )
    .preferredColorScheme(.dark)
}

