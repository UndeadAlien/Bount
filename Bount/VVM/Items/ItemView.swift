//
//  ItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ItemView: View {
    @StateObject var viewModel = ItemVM()
    
    @State var item: Item
    
    @Environment(\.presentationMode) var presentationMode
    
    var navigationTitle: String {
        return viewModel.isEditing ? "Edit Mode" : item.name
    }

    var body: some View {
        NavigationStack {
            itemForm
            
            deleteButton
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
                        message: Text("Are you sure you want to delete this item?"),
                        primaryButton: .destructive(Text("Delete")) {
                            viewModel.deleteItem(item: item) { success in
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
    
    var itemForm: some View {
        Form {
            Section(header: Text("Item ID").font(.headline)) {
                Text(item.id ?? "").font(.subheadline)
            }
            
            Section(header: Text("Item Name").font(.headline)) {
                if viewModel.isEditing {
                    TextField("Name", text: Binding(
                        get: { viewModel.editedName },
                        set: { newValue in
                            viewModel.editedName = newValue
                        }
                    ))
                    .keyboardType(.alphabet)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(item.name)
                        .font(.subheadline)
                }
            }

            Section(header: Text("Item Price").font(.headline)) {
                if viewModel.isEditing {
                    TextField("Price", text: Binding(
                        get: { String(viewModel.editedPrice) },
                        set: {
                            if let newValue = Int($0) {
                                viewModel.editedPrice = newValue
                            }
                        }
                    ))
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text("$ \(item.price ?? 0)")
                        .font(.subheadline)
                }
            }

            Section(header: Text("Item Type").font(.headline)) {
                if viewModel.isEditing {
                    Picker("Type", selection: $viewModel.editedType) {
                        ForEach(ItemType.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } else {
                    Text(item.type.rawValue)
                        .font(.subheadline)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Add custom toolbar buttons
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if viewModel.isEditing {
                        // Save changes to Firestore and exit edit mode
                        viewModel.saveChanges(
                            item: &item,
                            editedName: viewModel.editedName,
                            editedPrice: viewModel.editedPrice,
                            editedType: viewModel.editedType) { success in
                                if success {
                                    viewModel.isEditing.toggle()
                                }
                            }
                    } else {
                        // Enter edit mode
                        viewModel.isEditing.toggle()
                        // Initialize edited fields with the current values
                        viewModel.editedName = item.name
                        viewModel.editedPrice = item.price ?? 0
                        viewModel.editedType = item.type
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
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}


struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a placeholder item for preview
        let tempItem = Item(id: "123", name: "Sample Item", price: 20, type: .VODKA)
        
        // Pass the placeholder item to ItemView
        return ItemView(item: tempItem)
    }
}

