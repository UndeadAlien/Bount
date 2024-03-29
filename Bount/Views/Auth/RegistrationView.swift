//
//  RegistrationView.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @StateObject var viewModel = RegistrationVM()
    
    var body: some View {
        
        VStack {
            Text("Bount")
                .bold()
                .font(.system(size: 52))
                .padding()
            
            Form {
                
                HStack {
                    TextField("First Name", text: $viewModel.firstName)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .padding()
                    TextField("Last Name", text: $viewModel.lastName)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .padding()
                }
                
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding()
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .padding()
                
                
                
                Button {
                    // action
                    viewModel.createUser()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.blue)
                        Text("Create Account")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                .padding()

            }
            
        }
        
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
