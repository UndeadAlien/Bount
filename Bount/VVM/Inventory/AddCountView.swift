//
//  InventoryCountView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/17/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddCountView: View {
    @StateObject var viewModel = AddCountVM()

    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    @Environment(\.presentationMode) var presentationMode
    
    var filteredItems: [Item] {
        let searchText = viewModel.searchText.lowercased()
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                let itemName = item.name.lowercased()
                let itemType = item.type.rawValue.lowercased()
                return itemName.contains(searchText) || itemType.contains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(text: $viewModel.searchText)

                Form {
                    ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                        let itemsForType = filteredItemsForType(itemType)
                        if !itemsForType.isEmpty {
                            Section(header: Text(itemType.rawValue)) {
                                ForEach(itemsForType.sorted(by: { $0.name < $1.name }), id: \.self) { item in
                                    HStack {
                                        Text(item.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)

                                        Spacer()

                                        Stepper(
                                            "\(viewModel.itemCounts[item.id ?? ""] ?? 0)",
                                            value: Binding(
                                                get: { viewModel.itemCounts[item.id ?? ""] ?? 0 },
                                                set: { newValue in viewModel.itemCounts[item.id ?? ""] = newValue }
                                            ),
                                            in: 0...Int.max
                                        )
                                    }
                                }
                            }
                        }
                    }

                }
                .alert(isPresented: $viewModel.showingErrorAlert) {
                    // Showing alert for an empty inventory count
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage),
                        dismissButton: .cancel()
                    )
                }
                .navigationTitle("Inventory Count")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            viewModel.showingCancelConfirmationAlert = true
                        }
                        .foregroundColor(Color.red)
                        .alert(isPresented: $viewModel.showingCancelConfirmationAlert) {
                            // Showing an alert to confirm a cancellation of a count
                            Alert(
                                title: Text("Confirmation"),
                                message: Text("Are you sure you want to cancel this item?"),
                                primaryButton: .destructive(Text("Cancel")) {
                                    presentationMode.wrappedValue.dismiss()
                                    viewModel.reset()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.showingSubmitConfirmationAlert = true
                        }) {
                            Text("Submit")
                        }
                        .foregroundColor(Color.blue)
                        .alert(isPresented: $viewModel.showingSubmitConfirmationAlert) {
                            // Showing an alert to confirm a submission of a count
                            Alert(
                                title: Text("Confirmation"),
                                message: Text("Are you sure you want to submit the inventory count?"),
                                primaryButton: .destructive(Text("Submit")) {
                                    viewModel.uploadCountsToFirestore { success, error in
                                        if success {
                                            presentationMode.wrappedValue.dismiss()
                                            viewModel.reset()
                                        } else {
                                            viewModel.showingErrorAlert = true
                                            viewModel.errorMessage = error
                                        }
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
            
        }
    }
    
    func filteredItemsForType(_ itemType: ItemType) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}

struct AddCountView_Previews: PreviewProvider {
    static var previews: some View {
        AddCountView()
    }
}
