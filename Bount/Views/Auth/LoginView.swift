//
//  LoginView.swift
//  Bount
//
//  Created by Connor Hutchinson on 8/27/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginVM()
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                Text("BOUNT")
                    .bold()
                    .font(.system(size: 52))
                    .padding()
                
                // login form
                Form {
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .padding()
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .padding()
                    
                    Button {
                        viewModel.login()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                            Text("Login")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    .padding()

                }
                
                
                
                VStack {
                    Text("Don't have an account?")
                        .bold()
                        .padding(1)
                    NavigationLink("Create an Account", destination: RegistrationView())
                        .foregroundColor(.accentColor)
                        .bold()
                }
                .padding(.bottom, 50)
                
            }
        }
        
    }
}

#Preview {
    LoginView()
}
