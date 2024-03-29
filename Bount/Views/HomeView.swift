//
//  HomeView.swift
//  Bount
//
//  Created by Connor Hutchinson on 1/15/24.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // pull the user from firebase and display info
    @State var name: String = "Connor"
    @State var role: String = "Developer"

    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Gradients()
                
                VStack {
                    nameBar()
                    
                    homeMenuList()
                }
            }
            
        }
    }
    
    @ViewBuilder
    func nameBar() -> some View {
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
    
    @ViewBuilder
    func homeMenuList() -> some View {
        List {
            NavigationLink(destination: CountHistoryMonthView()) {
                Label("Count History", systemImage: "magnifyingglass")
                    .modifier(LabelMod(colorScheme: colorScheme))
            }
            .modifier(NavLinkMod())
            
            NavigationLink(destination: VendorView()) {
                Label("Vendors", systemImage: "person.line.dotted.person.fill")
                    .modifier(LabelMod(colorScheme: colorScheme))
            }
            .modifier(NavLinkMod())
            
            NavigationLink(destination: ItemListView()) {
                Label("Items", systemImage: "shippingbox.fill")
                    .modifier(LabelMod(colorScheme: colorScheme))
            }
            .modifier(NavLinkMod())
            
//            NavigationLink(destination: LocationView()) {
//                Label("Locations", systemImage: "location.fill")
//                    .modifier(LabelMod(colorScheme: colorScheme))
//            }
//            .modifier(NavLinkMod())
        }
        .listStyle(InsetListStyle())
    }
}

struct LabelMod: ViewModifier {
    var colorScheme: ColorScheme
    func body(content: Content) -> some View {
        content
            .font(.custom("ArialRoundedMTBold", size: 14))
            .fontWeight(.black)
            .fontDesign(.rounded)
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .padding(.vertical, 10)
    }
}

struct NavLinkMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowSeparatorTint(.purple.opacity(0.5))
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 500, height: 500)) {
    HomeView()
        .preferredColorScheme(.dark)
}
