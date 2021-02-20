//
//  CreateAccountView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-17.
//

import SwiftUI

struct CreateAccountView: View {
    
    // These will eventually be put in a ViewModel
    @State var fullname: String = ""
    @State var emailAddress: String = ""
    @State var password: String = ""
    
    var body: some View {
        
        VStack {
            
            LogoBannerView()
            
            Spacer()
            
            VStack{
                
                Text("Create Account")
                    .padding()
                    .font(.system(size:40))
                
                MenuTextField(title: "Enter your full name", input: $fullname)
                
                MenuTextField(title: "Enter your email address", input: $emailAddress)
                
                MenuTextField(title: "Enter your password", input: $password)
                
                //Create account button
                Button {
                    // do something - navigate to different screen
                } label: {
                    BigButton(title: "Create Account")
                    
                }
                .padding(.top)
                
                Text("or").font(.system(size:18))
                
                // Login with SSO Button
                Button {
                    // do something - navigate to different screen
                } label: {
                    BigButton(title: "Log In")
                }
                
            }
            
            Spacer()
            
            // Create Acc Button
            // TODO: Consider a different back button style - put this here to center the form
            Button {
                
            } label: {
                BigButton(title: "Go Back")
            }
            
            Spacer()
        }
        
    }
    
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
