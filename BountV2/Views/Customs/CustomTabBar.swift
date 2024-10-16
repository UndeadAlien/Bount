//
//  CustomTabBar.swift
//  Bount
//
//  Created by Connor Hutchinson on 3/7/24.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case profile = 1
}

struct CircleAddButton: View {
    var body: some View {
        ZStack {
            Image(systemName: "plus.circle")
                .font(.system(size: 60, weight: .light))
                .tint(.purple)
                
        }
        .frame(width: 60, height: 60)
        .background(
            ZStack {
                Circle()
                    .fill(Color("Background"))
                    .frame(width: 60, height: 60)
                    .shadow(color: Color("LightShadow"), radius: 4, x: -4, y: -4)
                    .shadow(color: Color("DarkShadow"), radius: 4, x: 4, y: 4)
            }
        )
    }
}

struct AddMenuView: View {
    var body: some View {
        Menu {
            NavigationLink("Add Item", destination: AddItemView())
            NavigationLink("Add Vendor", destination: AddVendorView())
            NavigationLink("Add Location", destination: AddLocationView())
            NavigationLink("Add Count", destination: AddLocationCount())
        } label: {
            CircleAddButton()
        }
        .offset(y: -50)
    }
}

struct CustomTabBar: View {
    
    @State private var selectedTab: Tabs = .home
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Gradients()
                
                switch selectedTab {
                case .home:
                    NavigationView {
                        HomeView()
                    }
                case .profile:
                    NavigationView {
                        ProfileView()
                    }
                }
            }
            
            tabBarItems
        }
        
    }
    
    var tabBarItems: some View {
        HStack {
            Button {
                selectedTab = .home
            } label: {
                CustomTabBarItem(buttonIcon: "house", buttonText: "Home", isActive: selectedTab == .home)
            }
            .tint(colorScheme == .dark ? .white : .black)
            .shadow(color: Color("DarkShadow"), radius: 4, x: 4, y: 4)
            
            addButton
            
            Button {
                selectedTab = .profile
            } label: {
                CustomTabBarItem(buttonIcon: "person", buttonText: "Profile", isActive: selectedTab == .profile)
            }
            .tint(colorScheme == .dark ? .white : .black)
            .shadow(color: Color("DarkShadow"), radius: 4, x: 4, y: 4)
            // MARK: disabled - not setup yet
            .disabled(true)
        }
        .background(Gradients())
        .frame(height: 72)
    }
    
    var addButton: some View {
        AddMenuView()
    }
}

#Preview {
    CustomTabBar()
        .preferredColorScheme(.dark)
}
