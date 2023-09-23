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
            Form {
                Section("Vendor Name") {
                    TextField("Enter vendor name", text: $viewModel.vendorName)
                }
                
                Section("Selected Items") {
                    ForEach(Array(viewModel.selectedItems), id: \.self) { selectedItem in
                        Text(selectedItem.name)
                    }
                }
                Section {
                    Button(action: {
                        viewModel.isSelectingItems = true
                    }) {
                        Text("Select Items")
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
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        viewModel.reset()
                    }
                    .foregroundColor(Color.red)
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
                    .foregroundColor(Color.blue)
                }
            }
        }
    }
}

struct AddVendorView_Previews: PreviewProvider {
    static var previews: some View {
        AddVendorView()
    }
}
