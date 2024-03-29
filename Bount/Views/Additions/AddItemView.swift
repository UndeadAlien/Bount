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
            InlineHeaderView(title: "Add New Item") {
                addItemForm()
            }
        }
    }
    
    @ViewBuilder
    func addItemForm() -> some View {
        Form {
            
            Section(header: 
                        Text("Item Name")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                TextField("Name", text: $viewModel.itemName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.alphabet)
                    .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section(header: 
                        Text("Item Type")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                Picker("Select Type", selection: $viewModel.itemType) {
                    ForEach(ItemType.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.navigationLink)
                .listStyle(InsetListStyle())
                .navigationBarTitle("Select Type", displayMode: .inline)
                .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section(header:
                        Text("Item Price")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                TextField("", text: Binding(
                    get: {
                        return viewModel.itemPrice.map { String($0) } ?? ""
                    },
                    set: { newValue in
                        viewModel.itemPrice = Int(newValue)
                    }
                ))
                .keyboardType(.decimalPad)
                .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section(header: 
                        Text("Item Vendors")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                Picker("Select Vendor", selection: $viewModel.itemVendor) {
                    Text("")
                        .tag(nil as Vendor?)

                    ForEach(vendors, id: \.self) { v in
                        Text(v.name)
                            .tag(v as Vendor?)
                    }
                }
                .pickerStyle(.navigationLink)
                .modifier(FontMod(size: 14, isBold: true))
            }
        }
        .alert(isPresented: $viewModel.showingErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .cancel()
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.reset()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color.red)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.addItemToFirestore(
                        name: viewModel.itemName,
                        price: viewModel.itemPrice,
                        type: viewModel.itemType,
                        vendor: viewModel.itemVendor
                    ) { success, error in
                        if success {
                            presentationMode.wrappedValue.dismiss()
                            viewModel.reset()
                        } else {
                            viewModel.showingErrorAlert = true
                            viewModel.errorMessage = error
                        }
                    }
                } label: {
                    Text("Submit")
                        .foregroundStyle(Color("Green1"))
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }
        }
    }
}
