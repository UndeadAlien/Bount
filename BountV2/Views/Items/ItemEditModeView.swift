//
//  ItemEditModeView.swift
//  Bount
//
//  Created by Connor Hutchinson on 10/8/24.
//

import SwiftUI

struct ItemEditModeView: View {
    @Binding var editedName: String
    @Binding var editedType: ItemType
    @Binding var isEditing: Bool
    var onSave: () -> Void
    var onCancel: () -> Void

    var body: some View {
        Form {
            Section(header: HeaderView(title: "Item Name")) {
                TextField("Name", text: $editedName)
                    .keyboardType(.alphabet)
                    .modifier(FontMod(size: 14, isBold: false))
            }

            Section(header: HeaderView(title: "Item Type")) {
                Picker("Type", selection: $editedType) {
                    ForEach(ItemType.allCases.sorted(by: { $0.rawValue < $1.rawValue }), id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.navigationLink)
                .modifier(FontMod(size: 14, isBold: false))
            }
        }
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: onSave) {
                    Text("Save")
                        .foregroundColor(Color("Green1"))
                        .cornerRadius(8)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .foregroundStyle(.red)
                        .modifier(FontMod(size: 18, isBold: true))
                }
            }
        }
    }
}

#Preview {
    @State var editedName = "Sample Item"
    @State var editedType: ItemType = .VODKA
    @State var isEditing = true
    
    return ItemEditModeView(
        editedName: $editedName,
        editedType: $editedType,
        isEditing: $isEditing,
        onSave: { print("Save tapped") },
        onCancel: { print("Cancel tapped") }
    )
    .preferredColorScheme(.dark)
}
