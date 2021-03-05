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

            }
            
            Spacer()
            
            Spacer()
        }
        
        
    }
    
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
