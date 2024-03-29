//
//  CountHistoryListView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/9/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CountHistoryListView: View {
    @ObservedObject var viewModel: CountHistoryVM

    var body: some View {
        InlineHeaderView() {
            historyList()
        }
    }
    
    @ViewBuilder
    func historyList() -> some View {
        List {
            ForEach(viewModel.countHistory.sorted(by: { ($1.date ?? Timestamp()) < ($0.date ?? Timestamp()) }), id: \.id) { inventoryCount in
                CountHistoryRowView(inventoryCount: inventoryCount)
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
