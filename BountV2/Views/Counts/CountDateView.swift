//
//  CountDateView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/2/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct CountDateView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = CountVM()
    
    @FirestoreQuery(collectionPath: "counts") var counts: [LocationCount]
    @FirestoreQuery(collectionPath: "items") var items: [Item]
    @FirestoreQuery(collectionPath: "locations") var locations: [Location]
    @FirestoreQuery(collectionPath: "vendors") var vendors: [Vendor]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.getUniqueDates(counts: counts), id: \.self) { date in
                    NavigationLink(destination: CountBreakdownByTimeView(
                        viewModel: viewModel,
                        items: items,
                        vendors: vendors,
                        locations: locations,
                        date: date,
                        counts: viewModel.getCounts(counts: counts, for: date)
                    )) {
                        CountDateItemView(date: date, viewModel: viewModel)
                    }
                }
            }
        }
    }
}

struct CountDateItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let date: Date
    @ObservedObject var viewModel: CountVM
    
    var body: some View {
        HStack {
            Text("🗓️")
                .padding(.vertical, 10)
            Text(viewModel.formatDate(date: date))
                .modifier(FontMod(size: 14, isBold: true))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CountDateView()
        .preferredColorScheme(.dark)
}
