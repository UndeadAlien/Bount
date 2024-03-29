//
//  AddCountItemView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/23/23.
//

import SwiftUI

struct AddCountItemView: View {
    
    @State var item: Item
    @ObservedObject var viewModel: AddCountVM
    
    var body: some View {
        
        NavigationStack {
            VStack {
                Stepper(
                    "\(viewModel.itemCounts[item.id ?? ""] ?? 0)",
                    value: Binding(
                        get: { viewModel.itemCounts[item.id ?? ""] ?? 0 },
                        set: { newValue in viewModel.itemCounts[item.id ?? ""] = newValue }
                    ),
                    in: 0...Int.max
                )
            }
            .navigationTitle(item.name)
        }
        
    }
}

#Preview {
    let item = Item(id: "1", name: "Sample Item", price: 10, type: .VODKA, vendor: nil, isActive: true)
    let viewModel = AddCountVM() // You may need to adjust this initialization based on your ViewModel
    
    return AddCountItemView(item: item, viewModel: viewModel)
}

