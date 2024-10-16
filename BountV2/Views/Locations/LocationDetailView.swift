//
//  LocationDetailView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/12/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct LocationDetailView: View {
    
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    
    @StateObject var viewModel = LocationDetailVM()
    
    @State var location: Location
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        vendorForm
    }
    
    var vendorForm: some View {
        Form {
            
            Section(header: 
                        Text("Location ID").font(.headline)
                            .modifier(FontMod(size: 16, isBold: true))
                            .foregroundStyle(Color.purple)
            ) {
                Text(location.id ?? "")
                    .font(.subheadline)
            }
            
            Section(header: 
                        Text("Location Name")
                            .modifier(FontMod(size: 16, isBold: true))
                            .foregroundStyle(Color.purple)
            ) {
                if viewModel.isEditing {
                    TextField("Name", text: Binding(
                        get: { viewModel.editedName },
                        set: { newValue in
                            viewModel.editedName = newValue
                        }
                    ))
                } else {
                    Text(location.name)
                        .font(.headline)
                }
            }

            
            if viewModel.isEditing {
                Section {
                    Button(action: {
                        viewModel.isSelectingItems = true
                    }) {
                        Text("Select Items")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isSelectingItems) {
            ItemSelectionView(selectedItems: $viewModel.selectedItems, items: items)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(viewModel.isEditing)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if viewModel.isEditing {
                        // Save changes to Firestore and exit edit mode
                        viewModel.saveChanges(
                            location: &location,
                            editedName: viewModel.editedName
                        ) { success in
                            if success {
                                viewModel.isEditing = false
                            }
                        }

                    } else {
                        viewModel.isEditing.toggle()
                        viewModel.editedName = location.name
                    }
                }) {
                    Text(viewModel.isEditing ? "Save" : "Edit")
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                // Add a "Cancel" button to exit edit mode
                if viewModel.isEditing {
                    Button("Cancel") {
                        // Exit edit mode without saving changes
                        viewModel.isEditing.toggle()
                        viewModel.selectedItems = Set<Item>()
                    }
                    .foregroundColor(.red)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                deleteButton
            }
        }
    }
    
    var deleteButton: some View {
        VStack {
            if viewModel.isEditing {
                Button(action: {
                    viewModel.showingDeleteConfirmationAlert = true
                }) {
                    Text("Delete")
                        .modifier(FontMod(size: 14, isBold: true))
                        .foregroundColor(Color.red)
                        .padding()
                }
                .alert(isPresented: $viewModel.showingDeleteConfirmationAlert) {
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Are you sure you want to delete this location?"),
                        primaryButton: .destructive(Text("Delete")) {
                            // delete button
                            viewModel.deleteLocation(location: location.id ?? "") { success in
                                if success {
                                    viewModel.showingDeleteConfirmationAlert = false
                                }
                            }
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    private var vendorName: String {
        return vendors.first { $0.id == location.id }?.name ?? "Loading..."
    }
}

#Preview {
    LocationDetailView(location:
        Location(
            id: "15Q0BsporYNSlvwHIe6O",
            name: "Bob's Shop"
        )
    )
}
