//
//  AddItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct AddItemView: View {
    
    @StateObject var viewModel = AddItemVM()
    
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("required")) {
                    //*** the item name (required)
                    TextField("Name", text: $viewModel.itemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.alphabet)
                    
                    Picker("Item Type", selection: $viewModel.itemType) {
                        ForEach(ItemType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .navigationBarTitle("Select Type", displayMode: .inline)
                }
                
                Section(header: Text("not required")) {
                    TextField("Price", text: Binding(
                        get: {
                            // Convert the Int? to a String for the TextField's text
                            return viewModel.itemPrice.map { String($0) } ?? ""
                        },
                        set: { newValue in
                            // Convert the String back to Int? and update viewModel.itemPrice
                            viewModel.itemPrice = Int(newValue)
                        }
                    ))
                    .keyboardType(.decimalPad)
                    
                    // the items vendor (not required)
                    Picker("Vendors", selection: $viewModel.itemVendor) {
                        Text("")
                            .tag(nil as Vendor?)

                        ForEach(vendors, id: \.self) { v in
                            Text(v.name)
                                .tag(v as Vendor?)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
            }
            .navigationTitle("Add Item")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.reset()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        viewModel.addItemToFirestore(
                            name: viewModel.itemName,
                            price: viewModel.itemPrice,
                            type: viewModel.itemType,
                            vendor: viewModel.itemVendor
                        ) { success in
                            if success {
                                presentationMode.wrappedValue.dismiss()
                                viewModel.reset()
                            }
                        }
                    }
                }
            }
        }
    }
}
