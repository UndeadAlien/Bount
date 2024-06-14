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
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAddItemView = false
    
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
            InlineHeaderView(title: "") {
                countForm()
            }
        }
    }
    
    @ViewBuilder
    func countForm() -> some View {
        List {
            ForEach(ItemType.allCases, id: \.rawValue) { itemType in
                let itemsForType = filteredItemsForType(itemType)
                if !itemsForType.isEmpty {
                    Section(header: Text(itemType.rawValue)
                                        .foregroundStyle(.purple)
                                        .modifier(FontMod(size: 18, isBold: true))
                    ) {
                        ForEach(itemsForType.sorted(by: { $0.name < $1.name }), id: \.self) { item in
                            HStack {
                                Text(item.name)
                                    .modifier(FontMod(size: 14, isBold: false))
                                    .foregroundColor(item.isActive ? .primary : .red)

                                Spacer()

                                Stepper(
                                    "\(viewModel.itemCounts[item.id ?? ""] ?? 0)",
                                    value: Binding(
                                        get: { viewModel.itemCounts[item.id ?? ""] ?? 0 },
                                        set: { newValue in viewModel.itemCounts[item.id ?? ""] = newValue }
                                    ),
                                    in: 0...Int.max
                                )
                                .modifier(FontMod(size: 14, isBold: true))
                                
//                                CustomStepper(
//                                    value: Binding(
//                                        get: { viewModel.itemCounts[item.id ?? ""] ?? 0 },
//                                        set: { newValue in viewModel.itemCounts[item.id ?? ""] = newValue }
//                                    ),
//                                    range: 0...Int.max
//                                )
                            }
                        }
                    }
                }
            }

        }
        .listStyle(InsetListStyle())
        .alert(isPresented: $viewModel.showingErrorAlert) {
            // Showing alert for an empty inventory count
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .cancel()
            )
        }
        .navigationBarBackButtonHidden(true)
        .searchable(text: $viewModel.searchText)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.showingCancelConfirmationAlert = true
                } label: {
                    Text("Cancel")
                        .modifier(FontMod(size: 18, isBold: true))
                }
                .foregroundStyle(Color.red)
                .alert(isPresented: $viewModel.showingCancelConfirmationAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to cancel this item?"),
                        primaryButton: .destructive(Text("Cancel")) {
                            dismiss()
                            viewModel.reset()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    self.showingAddItemView.toggle()
                } label: {
                    Text("Add Item")
                }
                .fullScreenCover(isPresented: $showingAddItemView, content: {
                    AddItemView()
                        .preferredColorScheme(.dark)
                })
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showingSubmitConfirmationAlert = true
                }) {
                    Text("Submit")
                        .foregroundStyle(Color("Green1"))
                        .modifier(FontMod(size: 18, isBold: true))
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
                                    dismiss()
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
    
    func filteredItemsForType(_ itemType: ItemType) -> [Item] {
        return filteredItems.filter { item in
            return item.type == itemType
        }
    }
}

#Preview {
    AddCountView()
        .preferredColorScheme(.dark)
}
