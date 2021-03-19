//
//  CreateAccountView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-17.
//

import SwiftUI

struct CreateAccountView: View {
    
    // Allows for popping view back to LogInView
    @Binding var showLogIn: Bool
    
    @EnvironmentObject var viewModel: UserAccountViewModel
    
    var body: some View {
        
        ZStack {
            
            if viewModel.showBanner {
                if viewModel.createSuccess {
                    // be nice to show a banner for success here
                    
                } else {
                    NotificationBanner(image: "exclamationmark.circle.fill", msg: viewModel.msg, color: .red)
                }
            }
            
            VStack {
                
                Spacer()
                
                VStack{
                    
                    Text("Create Account")
                        .padding()
                        .font(.system(size:40))
                    
                    MenuTextField(title: "Full name", input: $viewModel.user.name)
                    
                    MenuTextField(title: "Email address", input: $viewModel.user.email)
                    
                    MenuTextField(title: "Password", input: $viewModel.user.password, secure: true)
                    
                    // Create Account Link
                    NavigationLink(
                        destination: HomeView(),
                        isActive: $viewModel.createSuccess,
                        label: {
                            EmptyView()
                        })
                    
                    Button {
                        viewModel.createAccount()
                        //delayAlert()
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
        .onAppear {
            viewModel.showBanner = false
        }
        .onDisappear {
            viewModel.showBanner = false
        }
        
    }

}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView(showLogIn: .constant(false))
            .environmentObject(UserAccountViewModel())
    }
}
