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
                LogoBannerView()
                
                Spacer()
                
                VStack() {
                    
                    Text("Log In")
                        .padding()
                        .font(.system(size:40))
                    
                    MenuTextField(title: "Email address", input: $email)
                    
                    MenuTextField(title: "Password", input: $password)
                    
                    // Log In Button
                    Button {
                        
                    } label: {
                        BigButton(title: "Log In")
                    }
                    .padding(.top)
                    
                    Text("or sign in with")
                    
                    // SSO Button
                    Button {
                        
                    } label: {
                        BigButton(title: "SSO")
                    }
                    
                }
                
                Spacer()
                
                // Create Acc Button
                NavigationLink(destination: CreateAccountView()) {
                    BigButton(title: "Register Now")
                }
                
                Spacer()
            }
            .navigationBarTitle("Log In")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(email: "email address", password: "password")
    }
}




