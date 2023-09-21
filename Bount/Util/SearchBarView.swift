//
//  SearchBarView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/21/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    
    @State static var searchText: String = "Enter Query Here"
    
    static var previews: some View {
        SearchBarView(text: $searchText)
    }
}
