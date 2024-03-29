//
//  CountHistoryRowView.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/14/24.
//

import SwiftUI
import FirebaseFirestore

struct CountHistoryRowView: View {
    var inventoryCount: InventoryCount
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationLink {
            BreakdownView(items: inventoryCount.itemCountMappings)
        } label: {
            if let date = inventoryCount.date?.dateValue() {
                HStack {
                    Text("🗓️")
                        .padding(.vertical, 10)
                    Text("\(formatDate(date: date))")
                        .modifier(FontMod(size: 14, isBold: true))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE - MMMM d, yyyy - HH:mm a"
        return dateFormatter.string(from: date)
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 200, height: 50)) {
    CountHistoryRowView(inventoryCount: InventoryCount(date: Timestamp(), itemCountMappings: [
        InventoryCountMapping(itemID: "abc1", itemCount: 1),
        InventoryCountMapping(itemID: "abc2", itemCount: 2),
        InventoryCountMapping(itemID: "abc3", itemCount: 3),
    ]))
    .preferredColorScheme(.dark)
}
