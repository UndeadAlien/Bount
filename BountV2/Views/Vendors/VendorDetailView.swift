//
//  VendorInventoryView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct VendorDetailView: View {
    
    @FirestoreQuery(collectionPath: "vendors") private var vendors: [Vendor]
    @FirestoreQuery(collectionPath: "items") private var items: [Item]
    
    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = VendorInventoryVM()
    @State private var isExpanded: Bool = false
    @State var vendor: Vendor
    
    var body: some View {
        vendorForm
    }
    
    var saveEditButton: some View {
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
                .foregroundColor(Color("Green1"))
                .cornerRadius(8)
                .modifier(FontMod(size: 18, isBold: true))
        }
    }
    
    var vendorForm: some View {
        Form {
            if !viewModel.isEditing {
                Section(header: 
                            Text("Vendor ID")
                                .foregroundStyle(Color.purple)
                                .modifier(FontMod(size: 14, isBold: true))
                ) {
                    Text(vendor.id ?? "")
                        .modifier(FontMod(size: 14, isBold: true))
                }
            }
            
            Section(header: 
                        Text("Vendor Name")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                if viewModel.isEditing {
                    TextField("Name", text: Binding(
                        get: { viewModel.editedName },
                        set: { newValue in
                            viewModel.editedName = newValue
                        }
                    ))
                    .modifier(FontMod(size: 14, isBold: false))
                } else {
                    Text(vendor.name)
                        .modifier(FontMod(size: 14, isBold: true))
                }
            }
            
            if viewModel.isEditing {
                Section {
                    Button(action: {
                        viewModel.isSelectingItems = true
                    }) {
                        Text("Select Items")
                            .foregroundStyle(Color("secondaryColor"))
                            .modifier(FontMod(size: 14, isBold: true))
                    }
                }
            }
            
            Section(header: 
                        Text("Inventory")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                if viewModel.isEditing {
                    List(viewModel.selectedItems.sorted(by: { $0.name < $1.name }), id: \.id) { selectedItem in
                        Text(selectedItem.name)
                            .modifier(FontMod(size: 14, isBold: false))
                    }
                } else {
                    DisclosureGroup(
                        isExpanded: $isExpanded,
                        content: {
                            List(itemNames.sorted(), id: \.self) { itemName in
                                Text(itemName)
                                    .modifier(FontMod(size: 14, isBold: true))
                            }
                        },
                        label: {
                            Text(isExpanded ? "Hide Inventory" : "Show Inventory")
                                .modifier(FontMod(size: 14, isBold: true))
                        }
                    )
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
                saveEditButton
            }

            ToolbarItem(placement: .navigationBarLeading) {
                if viewModel.isEditing {
                    Button {
                        viewModel.isEditing.toggle()
                        viewModel.selectedItems = Set<Item>()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                            .modifier(FontMod(size: 18, isBold: true))
                    }
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                deleteButton
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
                        .modifier(FontMod(size: 14, isBold: true))
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

#Preview {
    VendorDetailView(vendor:
        Vendor(
            id: "15Q0BsporYNSlvwHIe6O",
            name: "Bob's Shop",
            inventory: ["1CJTAfQCturZABMwVNJ9", "1O1xURV3pqRndgF4MYqo"]
        )
    )
    .preferredColorScheme(.dark)
}
