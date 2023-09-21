//
//  HistoryItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/8/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CountHistoryView: View {
    @StateObject var viewModel = CountHistoryVM()

    var body: some View {
        NavigationStack {
            CountHistoryListView(viewModel: viewModel)
                .onAppear {
                    viewModel.fetchCountHistory()
                }
                .navigationTitle("Count History")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: AddCountView()) {
                            Label("", systemImage: "plus")
                        }
                    }
                }
        }
    }
}

struct CountHistoryListView: View {
    @ObservedObject var viewModel: CountHistoryVM

    var body: some View {
        Form {
            List {
                ForEach(viewModel.countHistory, id: \.id) { inventoryCount in
                    CountHistoryRowView(
                        viewModel: viewModel,
                        inventoryCount: inventoryCount
                    )
                }
                .onDelete { indexSet in
                    viewModel.selectedIndices = indexSet
                    viewModel.showingDeleteConfirmationAlert = true
                }
                .alert(isPresented: $viewModel.showingDeleteConfirmationAlert) {
                    Alert(
                        title: Text("Delete"),
                        message: Text("Are you sure you want to delete this count?"),
                        primaryButton: .destructive(Text("Delete")) {
                            for index in viewModel.selectedIndices {
                                viewModel.deleteCount(at: index)
                            }
                            viewModel.selectedIndices.removeAll()
                        },
                        secondaryButton: .cancel() {
                            viewModel.selectedIndices.removeAll()
                        }
                    )
                }
            }
        }
    }
}

struct CountHistoryRowView: View {
    @ObservedObject var viewModel: CountHistoryVM
    var inventoryCount: InventoryCount

    var body: some View {
        if let date = inventoryCount.date?.dateValue() {
            VStack {
                NavigationLink(destination: BreakdownView(date: Timestamp(date: date), items: inventoryCount.itemCountMappings)) {
                    Text("📅  \(viewModel.formatDate(date: date))")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(white: 0.95))
                )
                .shadow(radius: 5)
            }
        }
    }
}

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CountHistoryView()
    }
}
