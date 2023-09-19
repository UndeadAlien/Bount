//
//  HistoryItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/8/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct CountHistoryView: View {
    
    @StateObject var viewModel = CountHistoryVM()

    var body: some View {
        
        NavigationStack {
            Form {
                List(viewModel.countHistory, id: \.self) { c in
                    if let date = c.date {
                        VStack {
                            NavigationLink(destination:
                                BreakdownView(
                                    date: date,
                                    items: c.itemCountMappings
                                )
                            ) {
                                Text("📅 \(viewModel.formatDate(date: date.dateValue()))")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
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
            .onAppear {
                viewModel.fetchItems()
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

struct HistoryItemView_Previews: PreviewProvider {
    static var previews: some View {
        CountHistoryView()
    }
}
