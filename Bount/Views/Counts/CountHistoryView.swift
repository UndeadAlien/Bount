//
//  HistoryItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/8/23.
//

import SwiftUI
import FirebaseFirestore

struct CountHistoryView: View {
    @StateObject var viewModel: CountHistoryVM
    
    @State var inventoryCount: [InventoryCount]
    
    @Environment(\.colorScheme) var colorScheme
    
    var selectedMonth: String

    var body: some View {
        NavigationStack {
            VStack {
                InlineHeaderView(title: "\(selectedMonth) Counts") {
                    List {
                        ForEach(viewModel.filterCounts(by: selectedMonth), id: \.id) { inventoryCount in
                            CountHistoryRowView(inventoryCount: inventoryCount)
                        }
                    }
                    .listStyle(InsetListStyle())
                }
            }
        }
    }
}

