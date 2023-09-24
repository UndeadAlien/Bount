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

struct AddCountItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy item and a dummy view model for preview purposes
        let item = Item(id: "1", name: "Sample Item", price: 10, type: .VODKA, vendor: nil)
        let viewModel = AddCountVM() // You may need to adjust this initialization based on your ViewModel
        
        return AddCountItemView(item: item, viewModel: viewModel)
    }
}

