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
            VStack {
                if viewModel.isEditing {
                    InlineHeaderView(title: item.name) {
                        editMode()
                            .transition(.slide)
                    }
                    
                    deleteButton()
                } else {
                    InlineHeaderView(title: item.name) {
                        itemForm()
                            .transition(.slide)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.isEditing)
        }
    }
    
    @ViewBuilder
    func itemForm() -> some View {
        Form {
            Section(header:
                        Text("Item Name")
                .foregroundStyle(Color.purple)
                .modifier(FontMod(size: 14, isBold: true))
            ) {
                Text(item.name)
                    .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section(header:
                        Text("Item Price")
                .foregroundStyle(Color.purple)
                .modifier(FontMod(size: 14, isBold: true))
            ) {
                Text("$ \(item.price ?? 0)")
                    .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section(header:
                        Text("Item Type")
                .foregroundStyle(Color.purple)
                .modifier(FontMod(size: 14, isBold: true))
            ) {
                Text(item.type.rawValue)
                    .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section(header:
                        Text("Active Item")
                .foregroundStyle(Color.purple)
                .modifier(FontMod(size: 14, isBold: true))
            ) {
                Text(item.isActive ? "Yes" : "No")
                    .modifier(FontMod(size: 14, isBold: true))
                    .foregroundStyle(item.isActive ? Color("Green1") : .red)
                    
            }
        }
        .toolbar {
            // Add custom toolbar buttons
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Enter edit mode
                    viewModel.isEditing.toggle()
                    // Initialize edited fields with the current values
                    viewModel.editedName = item.name
                    viewModel.editedPrice = item.price ?? 0
                    viewModel.editedType = item.type
                    viewModel.editedActivity = item.isActive
                }) {
                    Text(viewModel.isEditing ? "Save" : "Edit")
                        .foregroundColor(Color("Green1"))
                        .cornerRadius(8)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }
            
            // Add custom toolbar buttons
            ToolbarItem(placement: .bottomBar) {
                Text(item.id ?? "")
                    .modifier(FontMod(size: 14, isBold: true))
            }
        }
        
    }
    
    @ViewBuilder
    func editMode() -> some View {
        Form {
            // item name
            Section(header:
                        Text("Item Name")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                TextField("Name", text: Binding(
                    get: { viewModel.editedName },
                    set: { newValue in
                        viewModel.editedName = newValue
                    }
                ))
                .keyboardType(.alphabet)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .modifier(FontMod(size: 14, isBold: false))
            }
            // item price
            Section(header:
                        Text("Item Price")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
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
                .modifier(FontMod(size: 14, isBold: false))
            }

            // item type
            Section(header:
                        Text("Item Type")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                Picker("Type", selection: $viewModel.editedType) {
                    ForEach(ItemType.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.navigationLink)
                .modifier(FontMod(size: 14, isBold: false))
            }
         
            // active item
            Section(header:
                        Text("Active Item")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                Toggle(
                    isOn: Binding(
                        get: { viewModel.editedActivity },
                        set: { newValue in
                            viewModel.editedActivity = newValue
                        }
                    ),
                    label: {
                        Text("Is Active?")
                            .modifier(FontMod(size: 14, isBold: false))
                    }
                )
                .toggleStyle(SwitchToggleStyle(tint: Color("secondaryColor")))
            }
        }
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .toolbar {
            // Add custom toolbar buttons
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Save changes to Firestore and exit edit mode
                    viewModel.saveChanges(
                        item: &item,
                        editedName: viewModel.editedName,
                        editedPrice: viewModel.editedPrice,
                        editedType: viewModel.editedType,
                        editedActivity: viewModel.editedActivity
                    ) { success in
                            if success {
                                viewModel.isEditing.toggle()
                            }
                        }
                }) {
                    Text(viewModel.isEditing ? "Save" : "Edit")
                        .foregroundColor(Color("Green1"))
                        .cornerRadius(8)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.isEditing.toggle()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }
        }
    }
    
    @ViewBuilder
    func deleteButton() -> some View {
        Button(action: {
            viewModel.showingDeleteConfirmationAlert = true
        }) {
            Text("Delete")
                .modifier(FontMod(size: 18, isBold: true))
                .foregroundColor(Color.red)
                .padding()
        }
        .alert(isPresented: $viewModel.showingDeleteConfirmationAlert) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Are you sure you want to delete \(item.name)?"),
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

#Preview {
    // Create a placeholder item for preview
    let tempItem = Item(id: "123", name: "Sample Item", price: 20, type: .VODKA, vendor: Vendor(name: "Testing", inventory: []), isActive: true)
    
    // Pass the placeholder item to ItemView
    return ItemView(item: tempItem)
        .preferredColorScheme(.dark)
}

