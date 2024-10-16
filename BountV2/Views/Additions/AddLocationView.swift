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
    
    @Environment(\.dismiss) var dismiss
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
            }
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $viewModel.isSelectingItems) {
                ItemSelectionView(selectedItems: $viewModel.selectedItems, items: items)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                        self.reset()
                    } label: {
                        Text("Cancel")
                            .foregroundStyle(.red)
                            .modifier(FontMod(size: 16, isBold: true))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.addLocationToFirebase { success, errorMessage in
                            if success {
                                dismiss()
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
