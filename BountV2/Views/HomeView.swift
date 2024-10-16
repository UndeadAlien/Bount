//
//  HomeView.swift
//  Bount
//
//  Created by Connor Hutchinson on 1/15/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var name: String = "Connor"
    @State var role: String = "Developer"

    var body: some View {
        NavigationStack {
            ZStack {
                
                Gradients()
                
                VStack {
                    nameBar
                    
                    homeMenuList
                }
            }
            
        }
    }
    
    var nameBar: some View {
        VStack(alignment: .leading) {
            Text("Hello, \(name)")
                .font(.custom("ArialRoundedMTBold", size: 24))
                .fontWeight(.black)
                .fontDesign(.rounded)
                .foregroundColor(.white)
                .padding(.vertical, 2)
                .shadow(color: Color("DarkShadow"), radius: 4, x: 4, y: 4)
            
            HStack {
                Image(systemName: "medal.fill")
                    .font(.custom("ArialRoundedMTBold", size: 15))
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                    .foregroundColor(.yellow)
                    .padding(.trailing, 2)
                    .shadow(color: Color("DarkShadow"), radius: 4, x: 4, y: 4)
                Text("\(role)")
                    .font(.custom("ArialRoundedMTBold", size: 17))
                    .fontWeight(.black)
                    .fontDesign(.rounded)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .shadow(color: Color("DarkShadow"), radius: 4, x: 4, y: 4)
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    var homeMenuList: some View {
        List {
            NavigationLink(destination: CountDateView()) {
                Label("Count History", systemImage: "magnifyingglass")
                    .modifier(FontMod(size: 16, isBold: true))
            }
            .modifier(NavLinkMod())
            
            NavigationLink(destination: VendorView()) {
                Label("Vendors", systemImage: "person.line.dotted.person.fill")
                    .modifier(FontMod(size: 16, isBold: true))
            }
            .modifier(NavLinkMod())
            
            NavigationLink(destination: ItemListView()) {
                Label("Items", systemImage: "shippingbox.fill")
                    .modifier(FontMod(size: 16, isBold: true))
            }
            .modifier(NavLinkMod())
            
            NavigationLink(destination: LocationView()) {
                Label("Locations", systemImage: "location.fill")
                    .modifier(FontMod(size: 16, isBold: true))
            }
            .modifier(NavLinkMod())
        }
        .listStyle(InsetListStyle())
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
