//
//  MainView.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/26/23.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var viewModel = TabBarVM()
    
    var body: some View {
        accountView
    }

    @ViewBuilder
    var accountView: some View {
        TabView {
            CountHistoryView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            VendorView()
                .tabItem {
                    Label("Vendors", systemImage: "person.fill")
                }
            ItemListView()
                .tabItem {
                    Label("Items", systemImage: "bag.fill")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
