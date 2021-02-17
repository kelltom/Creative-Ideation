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
        
        VStack {
            LogoBannerView()
            
            Spacer()
            
            VStack(spacing: 20) {
                
                Text("Log In")
                    .font(.largeTitle)
                
                TextField("email address", text: $email)
                    .padding()
                    .frame(width: 550, height: 60, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                    .font(.title2)
                
                TextField("password", text: $password)
                    .padding()
                    .frame(width: 550, height: 60, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                    .font(.title2)
                
                // Log In Button
                Button {
                    
                } label: {
                    Text("Log In")
                        .padding()
                        .frame(width: 550, height: 60, alignment: .center)
                        .background(Color("DarkCyan"))
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                        .font(.title2)
                }
                .padding(.top)
                
                // "Or sign in with" label
                Text("or sign in with")
                
                // SSO Button
                Button {
                    
                } label: {
                    Text("SSO")
                        .padding()
                        .foregroundColor(.black)
                        .frame(width: 550, height: 60, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                        .font(.title2)
                }
            }
            
            Spacer()
            
            // Create Acc Button
            Button {
                
            } label: {
                Text("Register Now")
                    .padding()
                    .foregroundColor(.black)
                    .frame(width: 550, height: 60, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                    .font(.title2)
            }
            
            Spacer()
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(email: "email address", password: "password")
    }
}




