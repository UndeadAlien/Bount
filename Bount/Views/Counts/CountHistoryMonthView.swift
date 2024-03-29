//
//  CountHistoryMonthView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/14/24.
//

import SwiftUI

struct CountHistoryMonthView: View {
    @StateObject var viewModel = CountHistoryVM()
    
    @Environment(\.colorScheme) var colorScheme
    
    let monthSymbols = DateFormatter().monthSymbols!
    
    var body: some View {
        
        NavigationStack {
            VStack {
                InlineHeaderView(title: "Months") {
                    monthList()
                }
            }
        }
        
    }
    
    @ViewBuilder
    func monthList() -> some View {
        List(monthSymbols, id: \.self) { month in
            NavigationLink {
                CountHistoryView(viewModel: viewModel, inventoryCount: viewModel.filterCounts(by: month), selectedMonth: month)
            } label: {
                Text(month)
                    .foregroundColor(
                        viewModel.isCurrentMonth(month: month)
                        ? .purple
                        : colorScheme == .dark ? .white : .black
                    )
                    .padding(.vertical, 10)
                    .modifier(FontMod(size: 14, isBold: true))
            }
            .foregroundColor(
                viewModel.isCurrentMonth(month: month)
                ? .purple
                : colorScheme == .dark ? .white : .black
            )
        }
        .onAppear {
            viewModel.fetchCountHistory()
        }
        .listStyle(InsetListStyle())
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 500, height: 1000)) {
    CountHistoryMonthView()
        .preferredColorScheme(.dark)
}
