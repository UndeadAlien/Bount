//
//  ItemFormView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/8/24.
//

import SwiftUI

struct ItemFormView: View {
    let item: Item

    var body: some View {
        Form {
            Section(header: HeaderView(title: "Item Name")) {
                Text(item.name)
                    .modifier(FontMod(size: 14, isBold: true))
            }

            Section(header: HeaderView(title: "Item Type")) {
                Text(item.type.rawValue)
                    .modifier(FontMod(size: 14, isBold: true))
            }
        }
    }
}

struct HeaderView: View {
    let title: String

    var body: some View {
        Text(title)
            .foregroundStyle(Color.purple)
            .modifier(FontMod(size: 14, isBold: true))
    }
}

#Preview {
    ItemFormView(item: Item.testItems[0])
}
