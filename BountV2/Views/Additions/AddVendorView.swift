//
//  AddVendorView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/18/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddVendorView: View {
    
    @StateObject var viewModel = AddVendorVM()
    
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            InlineHeaderView(title: "Add Vendor") {
                vendorForm()
            }
        }
    }
    
    @ViewBuilder
    func vendorForm() -> some View {
        Form {
            Section(header:
                        Text("Vendor Name")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                TextField("Enter vendor name", text: $viewModel.vendorName)
                    .modifier(FontMod(size: 14, isBold: true))
            }
            
            Section {
                Button(action: {
                    viewModel.isSelectingItems = true
                }) {
                    Text("Select Items")
                        .foregroundStyle(Color.purple)
                        .modifier(FontMod(size: 14, isBold: true))
                }
            }
            
            Section(header:
                        Text("Selected Items")
                            .foregroundStyle(Color.purple)
                            .modifier(FontMod(size: 14, isBold: true))
            ) {
                ForEach(Array(viewModel.selectedItems), id: \.self) { selectedItem in
                    Text(selectedItem.name)
                        .modifier(FontMod(size: 14, isBold: true))
                }
            }
            
        }
        .alert(isPresented: $viewModel.showingErrorAlert) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .cancel()
            )
        }
        .sheet(isPresented: $viewModel.isSelectingItems) {
            ItemSelectionView(selectedItems: $viewModel.selectedItems, items: items)
        }
        .navigationTitle("Add Vendor")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    viewModel.reset()
                } label: {
                    Text("Cancel")
                }
                .foregroundColor(Color.red)
                .modifier(FontMod(size: 18, isBold: true))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.addVendorToFirestore { success, error in
                        if success {
                            viewModel.reset()
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            viewModel.showingErrorAlert = true
                            viewModel.errorMessage = error
                        }
                    }
                }) {
                    Text("Submit")
                }
                .foregroundColor(Color("Green1"))
                .modifier(FontMod(size: 18, isBold: true))
            }
        }
    }
}

#Preview {
    AddVendorView()
        .preferredColorScheme(.dark)
}
