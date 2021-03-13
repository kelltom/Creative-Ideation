//
//  LoginView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-17.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    // Bound to CreateAccountView to enable popping view on btn click
    @State var showLogIn = false
    
    @State private var actionState: Int? = 0
    
    @State var email: String = ""
    @State var password: String = ""
    
    // This probably shouldn't go here
    let db = Firestore.firestore()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                VStack() {
                    
                    Text("Log In")
                        .padding()
                        .font(.system(size:40))
                    
                    MenuTextField(title: "Email address", input: $email)
                    
                    MenuTextField(title: "Password", input: $password, secure: true)
                    
                    // Log In Link
                    NavigationLink(destination: GroupView(), tag: 1, selection: $actionState) {
                        EmptyView()
                    }
                    
                    // Log In Button
                    Button {
                        // logic for determining if user entered proper credentials
                        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                            if error != nil {
                                print(error?.localizedDescription ?? "")
                                self.password = "" // reset password field
                            } else {
                                print("Success")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.actionState = 1
                                }
                            }
                        }
                    } label: {
                        BigButton(title: "Log In")
                    }
                    .padding(.top)
                    
                    Text("or")
                    
                    // Sign In with Google Button
                    Button {
                        // code here for Google Auth
                        //actionState = 1
                    } label: {
                        GoogleButton()
                    }
                    
                }
                
                // Create Acc Button
                HStack {
                    Text("New user?")
                    NavigationLink(destination: CreateAccountView(showLogIn: self.$showLogIn), isActive: self.$showLogIn) {
                        Text("Create an Account.")
                    }
                }
                .padding(.top, 20)
                
                Spacer()
            }
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

struct GoogleButton: View {
    
    var body: some View {
        
        HStack {
            
            Image("google")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 57)
                .padding(.horizontal, 10)
                .background(Color(.white))
                .cornerRadius(10)
                .padding(.leading, 1)
            
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
        .shadow(radius: 5, x: 5, y: 5)
        
    }
}




