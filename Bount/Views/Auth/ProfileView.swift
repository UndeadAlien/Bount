//
//  ProfileView.swift
//  Bount
//
//  Created by Connor Hutchinson on 9/4/23.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileVM()
    
    var body: some View {
        NavigationStack {
            
            if let user = viewModel.user {
                profile(user: user)
            }
            else {
                Image(systemName: "circle.dotted")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 125, height: 125)
                Text("Loading...")
            }
            
        }
        .onAppear {
            viewModel.fetch()
        }
    }
    
    @ViewBuilder
    func profile(user: User) -> some View {
        
        VStack {
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .frame(width: 125, height: 125)
                .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    Text(user.firstName)
                    Text(user.lastName)
                }
                .padding()
                
                HStack {
                    Text(user.email)
                }
                .padding()
            }
            .padding()
            
            Button("Log out") {
                viewModel.logOut()
            }
            .tint(.red)
            
            Spacer()
        }
        .navigationTitle("Profile")
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
