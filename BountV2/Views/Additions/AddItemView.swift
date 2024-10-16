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
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    itemNameSection()
                    itemTypeSection()
                    itemVendorsSection()
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
                    ToolbarItem(placement: .topBarLeading) {
                        leadingToolbarButton()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        trailingToolbarButton()
                    }
                }
            }
        }
    }
    
    private func itemNameSection() -> some View {
        Section(header: sectionHeader("Item Name")) {
            TextField("Name", text: $viewModel.itemName)
                .keyboardType(.alphabet)
                .modifier(FontMod(size: 14, isBold: true))
        }
    }
    
    private func itemTypeSection() -> some View {
        Section(header: sectionHeader("Item Type")) {
            Picker("Select Type", selection: $viewModel.itemType) {
                ForEach(ItemType.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type)
                }
            }
            .pickerStyle(.navigationLink)
            .modifier(FontMod(size: 14, isBold: true))
        }
    }
    
    private func itemVendorsSection() -> some View {
        Section(header: sectionHeader("Item Vendors")) {
            Picker("Select Vendor", selection: $viewModel.itemVendor) {
                Text("").tag(nil as Vendor?)
                
                ForEach(vendors, id: \.self) { vendor in
                    Text(vendor.name)
                        .tag(vendor as Vendor?)
                }
            }
            .pickerStyle(.navigationLink)
            .modifier(FontMod(size: 14, isBold: true))
        }
    }
    
    // Reusable section header for each form section
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .foregroundStyle(Color.purple)
            .modifier(FontMod(size: 14, isBold: true))
    }
    
    // Toolbar leading button for Cancel action
    private func leadingToolbarButton() -> some View {
        Button(action: {
            dismiss()
            viewModel.reset()
        }) {
            Text("Cancel")
                .foregroundStyle(Color.red)
                .modifier(FontMod(size: 18, isBold: true))
        }
    }
    
    // Toolbar trailing button for Submit action
    private func trailingToolbarButton() -> some View {
        Button(action: {
            viewModel.addItemToFirestore(
                name: viewModel.itemName,
                type: viewModel.itemType,
                vendor: viewModel.itemVendor,
                isActive: viewModel.isActive
            ) { success, error in
                if success {
                    dismiss()
                    viewModel.reset()
                } else {
                    viewModel.showingErrorAlert = true
                    viewModel.errorMessage = error
                }
            }
        }) {
            Text("Submit")
                .foregroundStyle(Color("Green1"))
                .modifier(FontMod(size: 18, isBold: true))
        }
    }
}

#Preview {
    AddItemView()
        .preferredColorScheme(.dark)
}
