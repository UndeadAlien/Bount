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
                .padding(.horizontal, 10)
                .cornerRadius(10)
                .shadow(radius: 2)
                .font(.title2)
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                .overlay {
                    HStack {
                        Spacer()
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.title2)
                                .padding(.trailing)
                        }
                    }
                }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    
    @State static var searchText: String = "Search"
    
    static var previews: some View {
        SearchBarView(text: $searchText)
    }
}
