//
//  AddLocationCount.swift
//  Bount
//
//  Created by Connor Hutchinson on 6/19/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct AddLocationCount: View {
    
    @StateObject private var viewModel = CountVM()
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @FirestoreQuery(collectionPath: "locations") private var locations: [Location]
    @FirestoreQuery(collectionPath: "items") private var items: [Item]
    
    var body: some View {
        NavigationStack {
            List {
                locationsListView
            }
            .listStyle(InsetListStyle())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                cancelButton
                submitButton
            }
        }
    }
    
    private var locationsListView: some View {
        ForEach(locations.sorted(by: { $0.name < $1.name }), id: \.id) { loc in
            NavigationLink(destination: AddCountView(viewModel: viewModel, location: loc, items: items)) {
                Text(loc.name)
                    .foregroundColor(locationColor(for: loc))
                    .modifier(FontMod(size: 18, isBold: true))
            }
            .frame(height: 42)
        }
    }
    
    private var cancelButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { viewModel.showingCancelConfirmationAlert = true }) {
                Text("Cancel")
                    .foregroundStyle(.red)
                    .modifier(FontMod(size: 18, isBold: true))
            }
            .alert(isPresented: $viewModel.showingCancelConfirmationAlert) {
                cancelConfirmationAlert
            }
        }
    }
    
    private var submitButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.submitCount { success in
                    if success {
                        dismiss()
                    }
                }
            } label: {
                Text("Submit")
                    .foregroundStyle(Color("Green1"))
                    .modifier(FontMod(size: 18, isBold: true))
            }
            .alert(isPresented: $viewModel.showingSubmitConfirmationAlert) {
                submitConfirmationAlert
            }
        }
    }
    
    private func locationColor(for location: Location) -> Color {
        viewModel.submittedLocations.contains(location)
            ? Color("Green1")
            : colorScheme == .dark ? .white : .black
    }
    
    private var cancelConfirmationAlert: Alert {
        Alert(
            title: Text("Confirmation"),
            message: Text("Are you sure you want to cancel this count?"),
            primaryButton: .destructive(Text("Cancel")) {
                dismiss()
            },
            secondaryButton: .cancel()
        )
    }
    
    private var submitConfirmationAlert: Alert {
        Alert(
            title: Text("Confirmation"),
            message: Text("Are you sure you want to submit this count?"),
            primaryButton: .destructive(Text("Submit")) {
                dismiss()
            },
            secondaryButton: .cancel()
        )
    }
}

#Preview {
    AddLocationCount()
        .preferredColorScheme(.dark)
}
