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
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.saveVendorToFirestore { success in
                            if success {
                                viewModel.reset()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Submit")
                    }
                }
            }
        }
    }
}

struct ItemSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var selectedItems: Set<Item>
    let items: [Item]
    
    var body: some View {
        NavigationView {
            List(items, id: \.self) { item in
                MultipleSelectionRow(
                    title: item.name,
                    isSelected: Binding(
                        get: { self.selectedItems.contains(item) },
                        set: { newValue in
                            if newValue {
                                self.selectedItems.insert(item)
                            } else {
                                self.selectedItems.remove(item)
                            }
                        }
                    )
                )
            }
            .navigationBarTitle("Select Items")
            .navigationBarItems(
                trailing: Button("Done") {
                    // Dismiss the sheet when the "Done" button is tapped
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Binding<Bool>

    var body: some View {
        Toggle(isOn: isSelected) {
            Text(title)
        }
    }
}

struct AddVendorView_Previews: PreviewProvider {
    static var previews: some View {
        AddVendorView()
    }
}
