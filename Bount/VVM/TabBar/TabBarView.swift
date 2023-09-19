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
            ItemView()
                .tabItem {
                    Label("Items", systemImage: "bag.fill")
                }
            ProfileView() // Profile View
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
