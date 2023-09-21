//
//  VendorInventoryView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct VendorInventoryView: View {
    
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    @StateObject var viewModel = VendorInventoryVM()
    
    @State var vendor: Vendor
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        vendorForm
        
        deleteButton
    }
    
    var vendorForm: some View {
        Form {
            
            Section(header: Text("Vendor ID").font(.headline)) {
                Text(vendor.id ?? "")
                    .font(.subheadline)
            }
            
            Section(header: Text("Vendor Name").font(.headline)) {
                if viewModel.isEditing {
                    TextField("Name", text: Binding(
                        get: { viewModel.editedName },
                        set: { newValue in
                            viewModel.editedName = newValue
                        }
                    ))
                } else {
                    Text(vendor.name)
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
                            vendor: &vendor,
                            editedName: viewModel.editedName,
                            editedInventory: viewModel.selectedItems.map { $0.id ?? "" }
                        ) { success in
                            if success {
                                viewModel.isEditing = false
                            }
                        }

                    } else {
                        // Enter edit mode
                        viewModel.isEditing.toggle()
                        // Initialize edited fields with the current values
                        viewModel.editedName = vendor.name
                        // Populate selectedItems with the initial inventory items
                        viewModel.selectedItems = Set(items.filter { vendor.inventory.contains($0.id ?? "") })

                    }
                }) {
                    Text(viewModel.isEditing ? "Save" : "Edit")
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8) // Add rounded corners
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
                    .foregroundColor(.blue)
                }
            }
        }
    }
    
    var deleteButton: some View {
        VStack {
            if viewModel.isEditing {
                Button(action: {
                    viewModel.showingDeleteConfirmationAlert = true
                }) {
                    Text("Delete")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.red)
                        .padding()
                }
                .alert(isPresented: $viewModel.showingDeleteConfirmationAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete this vendor?"),
                        primaryButton: .destructive(Text("Delete")) {
                            // delete button
                            viewModel.deleteVendor(vendor: vendor.id ?? "") { success in
                                if success {
                                    viewModel.showingDeleteConfirmationAlert = false
                                }
                            }
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    private var vendorName: String {
        return vendors.first { $0.id == vendor.id }?.name ?? "Loading..."
    }
    
    private var itemNames: [String] {
        return vendor.inventory.compactMap { itemID in
            items.first { $0.id == itemID }?.name
        }
    }

}

struct VendorInventoryView_Previews: PreviewProvider {
    static var previews: some View {
        VendorInventoryView(vendor:
            Vendor(
                id: "15Q0BsporYNSlvwHIe6O",
                name: "Bob's Shop",
                inventory: ["1CJTAfQCturZABMwVNJ9", "1O1xURV3pqRndgF4MYqo"]
            )
        )
    }
}
