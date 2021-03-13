//
//  CreateAccountView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-17.
//

import SwiftUI
import Firebase

struct CreateAccountView: View {
    
    // Allows for popping view back to LogInView
    @Binding var showLogIn: Bool
    
    // These will eventually be put in a ViewModel
    @State var fullname: String = ""
    @State var emailAddress: String = ""
    @State var password: String = ""
    
    let db = Firestore.firestore()
    
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
//                NavigationLink(destination: UserInfoView()) {
//                    BigButton(title: "Create Account")
//                }
//                .padding(.top)
                
                Button {
                    // Add a new document with a generated ID
                    Auth.auth().createUser(withEmail: emailAddress, password: password)
                    { (result, error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "Error creating account")
                        } else {
                            print("success")
                        }
                    }
                } label: {
                    BigButton(title: "Create Account")
                }
                
                // Already have account Button
                HStack {
                    Text("Already have an account?")
                    Button(action: {self.showLogIn = false}) {
                        Text("Log In.")
                    }
                }
                .padding(.top, 20)
                
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
        
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(showLogIn: .constant(false))
    }
}
