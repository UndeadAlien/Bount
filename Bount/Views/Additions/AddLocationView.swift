//
//  AddLocationView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/8/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct AddLocationView: View {
    
    @StateObject var viewModel = AddLocationVM()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    func reset() {
        self.viewModel.locationName = ""
        self.viewModel.selectedItems.removeAll()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Location Name") {
                    TextField("Enter location name", text: $viewModel.locationName)
                }
                Section {
                    Button(action: {
                        viewModel.isSelectingItems = true
                    }) {
                        Text("Select Items")
                    }
                }
                
                if !viewModel.selectedItems.isEmpty {
                    Section("Selected Items") {
                        ForEach(Array(viewModel.selectedItems), id: \.self) { selectedItem in
                            Text(selectedItem.name)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $viewModel.isSelectingItems) {
                ItemSelectionView(selectedItems: $viewModel.selectedItems, items: items)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                        self.reset()
                    }
                    .foregroundColor(Color.red)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addLocationToFirebase { success, errorMessage in
                            if success {
                                presentationMode.wrappedValue.dismiss()
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

#Preview {
    AddLocationView()
        .preferredColorScheme(.dark)
}
