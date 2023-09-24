//
//  VendorListView.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct VendorView: View {
    
    @StateObject var viewModel = VendorVM()
    
    @FirestoreQuery(collectionPath: "vendors") private var vendors: [Vendor]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        NavigationStack {
            Form {
                List(vendors, id: \.self) { vendor in
                    VStack {
                        NavigationLink(destination: VendorInventoryView(vendor: vendor)) {
                            Text(vendor.name)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
            .navigationTitle("Vendors")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddVendorView()) {
                        Label("", systemImage: "plus")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
        }
        
    }
}

struct VendorListView_Previews: PreviewProvider {
    static var previews: some View {
        VendorView()
    }
}
