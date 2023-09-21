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
        if viewModel.searchText.isEmpty {
            return items
        } else {
            return items.filter {
                $0.name.localizedCaseInsensitiveContains(viewModel.searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                SearchBarView(text: $viewModel.searchText)

                Form {
                    List(filteredItems, id: \.id) { item in
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
                .navigationTitle("Inventory Count")
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            viewModel.showingCancelConfirmationAlert = true
                        }
                        .alert(isPresented: $viewModel.showingCancelConfirmationAlert) {
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
                        .alert(isPresented: $viewModel.showingSubmitConfirmationAlert) {
                            Alert(
                                title: Text("Confirmation"),
                                message: Text("Are you sure you want to submit the inventory count?"),
                                primaryButton: .destructive(Text("Submit")) {
                                    viewModel.uploadCountsToFirestore { success in
                                        if success {
                                            presentationMode.wrappedValue.dismiss()
                                            viewModel.reset()
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
}

struct AddCountView_Previews: PreviewProvider {
    static var previews: some View {
        AddCountView()
    }
}
