//
//  LocationDetailView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/12/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct LocationDetailView: View {
    
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    @StateObject var viewModel = LocationDetailVM()
    
    @State var location: Location
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        vendorForm
    }
    
    var vendorForm: some View {
        Form {
            
            Section(header: Text("Location ID").font(.headline)) {
                Text(location.id ?? "")
                    .font(.subheadline)
            }
            
            Section(header: Text("Location Name").font(.headline)) {
                if viewModel.isEditing {
                    TextField("Name", text: Binding(
                        get: { viewModel.editedName },
                        set: { newValue in
                            viewModel.editedName = newValue
                        }
                    ))
                } else {
                    Text(location.name)
                        .font(.headline)
                }
            }
            
            Section(header: Text("Inventory").font(.headline)) {
                if viewModel.isEditing {
                    List(viewModel.selectedItems.sorted(by: { $0.name < $1.name }), id: \.id) { selectedItem in
                        Text(selectedItem.name)
                    }
                } else {
                    List(itemNames, id: \.self) { itemName in
                        Text(itemName)
                    }
                }
            }

            
            if viewModel.isEditing {
                Section {
                    Button(action: {
                        viewModel.isSelectingItems = true
                    }) {
                        Text("Select Items")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isSelectingItems) {
            ItemSelectionView(selectedItems: $viewModel.selectedItems, items: items)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if viewModel.isEditing {
                        // Save changes to Firestore and exit edit mode
                        viewModel.saveChanges(
                            location: &location,
                            editedName: viewModel.editedName,
                            editedInventory: viewModel.selectedItems.map { $0.id ?? "" }
                        ) { success in
                            if success {
                                viewModel.isEditing = false
                            }
                        }

                    } else {
                        viewModel.isEditing.toggle()
                        viewModel.editedName = location.name
                        viewModel.selectedItems = Set(items.filter { location.inventory.contains($0.id ?? "") })
                    }
                }) {
                    Text(viewModel.isEditing ? "Save" : "Edit")
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                // Add a "Cancel" button to exit edit mode
                if viewModel.isEditing {
                    Button("Cancel") {
                        // Exit edit mode without saving changes
                        viewModel.isEditing.toggle()
                        viewModel.selectedItems = Set<Item>()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private var vendorName: String {
        return vendors.first { $0.id == location.id }?.name ?? "Loading..."
    }
    
    private var itemNames: [String] {
        return location.inventory.compactMap { itemID in
            items.first { $0.id == itemID }?.name
        }
    }
}

#Preview {
    LocationDetailView(location:
        Location(
            id: "15Q0BsporYNSlvwHIe6O",
            name: "Bob's Shop",
            inventory: ["1CJTAfQCturZABMwVNJ9", "1O1xURV3pqRndgF4MYqo"]
        )
    )
}
