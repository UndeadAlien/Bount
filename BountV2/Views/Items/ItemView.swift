//
//  ItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/13/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ItemView: View {
    @StateObject var viewModel = ItemVM()
    @State var item: Item
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isEditing {
                    InlineHeaderView(title: item.name) {
                        ItemEditModeView(
                            editedName: $viewModel.editedName,
                            editedType: $viewModel.editedType,
                            isEditing: $viewModel.isEditing,
                            onSave: save,
                            onCancel: { viewModel.isEditing.toggle() }
                        )
                        .transition(.slide)
                    }

                    DeleteButtonView(itemName: item.name, onDelete: delete, isShowingAlert: $viewModel.showingDeleteConfirmationAlert)
                } else {
                    InlineHeaderView(title: item.name) {
                        ItemFormView(item: item)
                            .transition(.slide)
                    }
                }
            }
            .animation(.easeInOut, value: viewModel.isEditing)
        }
    }

    private func save() {
        viewModel.saveChanges(
            item: &item,
            editedName: viewModel.editedName,
            editedType: viewModel.editedType,
            editedActivity: viewModel.editedActivity
        ) { success in
            if success {
                viewModel.isEditing.toggle()
            }
        }
    }

    private func delete() {
        viewModel.deleteItem(item: item) { success in
            if success {
                viewModel.showingDeleteConfirmationAlert = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct DeleteButtonView: View {
    var itemName: String
    var onDelete: () -> Void

    @Binding var isShowingAlert: Bool

    var body: some View {
        Button(action: {
            isShowingAlert = true
        }) {
            Text("Delete")
                .foregroundColor(.red)
                .bold()
                .font(.title2)
                .padding()
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Are you sure you want to delete \(itemName)?"),
                primaryButton: .destructive(Text("Delete"), action: onDelete),
                secondaryButton: .cancel()
            )
        }
    }
}


#Preview {
    let tempItem = Item(
        id: "123",
        name: "Sample Item",
        type: .VODKA,
        vendor: Vendor(
            name: "Testing",
            inventory: []
        )
    )
    
    return ItemView(item: tempItem)
        .preferredColorScheme(.dark)
}
