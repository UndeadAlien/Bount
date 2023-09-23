//
//  ItemTypesView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/22/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ItemTypesView: View {
    
    @FirestoreQuery(collectionPath: "types") var itemTypes: [ItemTypes]
    
    @State private var isEditing = false
    @State private var editedType = ""
    
    var body: some View {
        NavigationStack {
            Form {
                List(itemTypes, id: \.self) { type in
                    if isEditing {
                        TextField("Type", text: $editedType)
                    } else {
                        Text(type.type.uppercased())
                    }
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button {
                        // edit the object
                        isEditing = true
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                    .tint(.indigo)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EmptyView()) {
                        Label("", systemImage: "plus")
                    }
                }
            }
        }
    }
}

struct ItemTypesView_Previews: PreviewProvider {
    static var previews: some View {
        ItemTypesView()
    }
}
