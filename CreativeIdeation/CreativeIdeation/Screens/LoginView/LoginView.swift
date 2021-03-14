//
//  LoginView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-17.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var showLogIn = false
    @State private var showBanner: Bool = false
    @State private var actionState: Int? = 0
    
    @State var email: String = ""
    @State var password: String = ""
    
    @State var bannerImage: String = ""
    @State var bannerColor: Color = .red
    @State var bannerMsg: String = ""
    
    // This probably shouldn't go here
    let db = Firestore.firestore()
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                if showBanner {
                    NotificationBanner(image: bannerImage, msg: bannerMsg, color: bannerColor)
                }
                
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
                            // Authenticate user credentials
                            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                                if error != nil {
                                    print(error?.localizedDescription ?? "")
                                    self.password = "" // reset password field
                                    
                                    bannerMsg = error?.localizedDescription ?? "Login Failed, Try Again"
                                    bannerColor = Color.red
                                    bannerImage = "exclamationmark.circle.fill"
                                    
                                    withAnimation {
                                        showBanner = true
                                    }
                                    delayAlert()
                                } else {
                                    print("Success")
                                    bannerMsg = "Success"
                                    bannerColor = Color.green
                                    bannerImage = "checkmark.circle.fill"
                                    
                                    withAnimation {
                                        showBanner = true
                                    }
                                    delayAlert()
                                    
                                    // Navigate to Team View
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
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation{
                showBanner = false
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
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




