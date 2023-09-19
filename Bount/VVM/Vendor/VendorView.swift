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
    
    var body: some View {
        
        NavigationStack {
            Form {
                List(vendors, id: \.self) { vendor in
                    VStack {
                        NavigationLink(destination: VendorInventoryView(vendorID: vendor.id!, inventory: vendor.inventory)) {
                            Text(vendor.name)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(white: 0.95))
                    )
                    .shadow(radius: 5)
                }
            }
            .navigationTitle("Vendors")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddVendorView()) {
                        Label("", systemImage: "plus")
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
