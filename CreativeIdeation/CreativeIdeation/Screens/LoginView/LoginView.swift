//
//  LoginView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-17.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                VStack() {
                    
                    Text("Log In")
                        .padding()
                        .font(.system(size:40))
                    
                    MenuTextField(title: "Email address", input: $email)
                    
                    MenuTextField(title: "Password", input: $password)
                    
                    // Log In Button
                    NavigationLink(destination: GroupView()) {
                        BigButton(title: "Log In")
                    }
                    .padding(.top)
                    
                    Text("or")
                    
                    // Sign In with Google Button
                    Button {
                        
                    } label: {
                        GoogleButton()
                    }
                    
                }
                
                // Create Acc Button
                HStack {
                    Text("New user?")
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Create an Account.")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("Log In")
            .navigationBarHidden(true)
//            .navigationBarTitle("Log In", displayMode: .large)
//            .toolbar(content: {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    LogoBannerView()
//                }
//            })
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(email: "email address", password: "password")
    }
}

struct GoogleButton: View {
    
    var body: some View {
        HStack {
            Image(systemName: "arrowtriangle.forward.square.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .padding(.leading, 4)
            
            Spacer()
            
            Text("Sign in with Google")
                .offset(x: -25)
            
            Spacer()
        }
        .frame(width: 550, height: 60, alignment: .center)
        .background(Color(.blue))
        .foregroundColor(.white)
        .cornerRadius(10)
        .font(.title2)
        .padding()
    }
}




