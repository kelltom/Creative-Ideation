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
    
    @State private var actionState: Int? = 0
    
    // These will eventually be put in a ViewModel
    @State var fullname: String = ""
    @State var emailAddress: String = ""
    @State var password: String = ""
    
    @State var errorMsg: String = ""
    @State private var showError: Bool = false
    
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        ZStack {
            
            if showError {
                NotificationBanner(image: "exclamationmark.circle.fill", msg: errorMsg, color: .red)
            }
            
            VStack {
                
                Spacer()
                
                VStack{
                    
                    Text("Create Account")
                        .padding()
                        .font(.system(size:40))
                    
                    MenuTextField(title: "Full name", input: $fullname)
                    
                    MenuTextField(title: "Email address", input: $emailAddress)
                    
                    MenuTextField(title: "Password", input: $password)
                    
                    // Create Account Link
                    NavigationLink(destination: GroupView(), tag: 1, selection: $actionState) {
                        EmptyView()
                    }
                    
                    Button {
                        // Add a new document with a generated ID
                        Auth.auth().createUser(withEmail: emailAddress, password: password)
                        { authResult, error in
                            if error != nil {
                                print(error?.localizedDescription ?? "Error creating account")
                                withAnimation {
                                    errorMsg = error?.localizedDescription ?? "Error creating account"
                                    showError.toggle()
                                }
                                delayAlert()
                            } else {
                                print("Success")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.actionState = 1
                                }
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
    
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation{
                showError.toggle()
            }
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateAccountView(showLogIn: .constant(false))
            CreateAccountView(showLogIn: .constant(false))
        }
    }
}
