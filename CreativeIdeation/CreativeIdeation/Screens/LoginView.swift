//
//  LoginView.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-17.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    // Allows for CreateAccount View to jump back to this View
    @State var showLogIn = false
    
    // May be used later
    //@State private var actionState: Int? = 0
    
    @EnvironmentObject var viewModel: UserAccountViewModel
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                if viewModel.showBanner {
                    if !viewModel.authSuccess {
                        NotificationBanner(image: "exclamationmark.circle.fill", msg: viewModel.msg, color: .red)
                    }
                }
                
                VStack {
                    
                    Spacer()
                    
                    VStack() {
                        
                        Text("Log In")
                            .padding()
                            .font(.system(size:40))
                        
                        MenuTextField(title: "Email address", input: $viewModel.user.email)
                        
                        MenuTextField(title: "Password", input: $viewModel.user.password, secure: true)
                        
                        // Log In Link
                        NavigationLink(
                            destination: HomeView(),
                            isActive: $viewModel.authSuccess,
                            label: {
                                EmptyView()
                            })
                        
                        // Log In Button
                        Button {
                            viewModel.authenticate()
                        } label: {
                            BigButton(title: "Log In")
                        }
                        .padding(.top)
                        
                        // Create Acc Button
                        HStack {
                            Text("New user?")
                            NavigationLink(destination: CreateAccountView(showLogIn: self.$showLogIn), isActive: self.$showLogIn) {
                                Text("Create an Account.")
                            }
                        }
                        .padding(.top, 20)
                        
                        Text("or")
                            .hidden()
                        
                        // Sign In with Google Button
                        Button {
                            // code here for Google Auth
                            //actionState = 1
                        } label: {
                            GoogleButton()
                        }
                        .hidden()
                        
                    }
                    
                    Spacer()
                }
                .navigationBarHidden(true)
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserAccountViewModel())
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



