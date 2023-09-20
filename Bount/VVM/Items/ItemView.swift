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
    
    @State private var isEditing = false
    @State private var editedName: String = ""
    @State private var editedPrice: Int = 0
    @State private var editedType: ItemType = .VODKA
    
    @State var item: Item
    
    var navigationTitle: String {
        return isEditing ? "Edit Mode" : item.name
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Item ID").font(.headline)) {
                    Text(item.id ?? "").font(.subheadline)
                }
                
                Section(header: Text("Item Name").font(.headline)) {
                    if isEditing {
                        TextField("Name", text: Binding(
                            get: { editedName },
                            set: { newValue in
                                editedName = newValue
                            }
                        ))
                    } else {
                        Text(item.name)
                            .font(.subheadline)
                    }
                }

                Section(header: Text("Item Price").font(.headline)) {
                    if isEditing {
                        TextField("Price", text: Binding(
                            get: { String(editedPrice) },
                            set: {
                                if let newValue = Int($0) {
                                    editedPrice = newValue
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
                    if isEditing {
                        Picker("Type", selection: $editedType) {
                            ForEach(ItemType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                                    .tag(type)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } else {
                        Text(item.type.rawValue).font(.subheadline)
                    }
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarBackButtonHidden(isEditing)
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Add custom toolbar buttons
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if isEditing {
                            // Save changes to Firestore and exit edit mode
                            viewModel.saveChanges(
                                item: &item,
                                editedName: editedName,
                                editedPrice: editedPrice,
                                editedType: editedType) { success in
                                    if success {
                                        isEditing.toggle()
                                    }
                                }
                        } else {
                            // Enter edit mode
                            isEditing.toggle()
                            // Initialize edited fields with the current values
                            editedName = item.name
                            editedPrice = item.price ?? 0
                            editedType = item.type
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8) // Add rounded corners
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    // Add a "Cancel" button to exit edit mode
                    if isEditing {
                        Button("Cancel") {
                            // Exit edit mode without saving changes
                            isEditing.toggle()
                        }
                        .foregroundColor(.blue)
                    }
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

