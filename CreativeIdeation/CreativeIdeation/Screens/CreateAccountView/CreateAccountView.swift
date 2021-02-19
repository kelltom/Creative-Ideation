//
//  CreateAccountView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-17.
//

import SwiftUI

struct CreateAccountView: View {
    
    @State var firstname: String = ""
    @State var emailAddress: String = ""
    @State var password: String = ""
    
    
    var body: some View {
        
        
        VStack {
            LogoBannerView()
            Spacer()
            VStack{
                
                Text("Create Account").padding().font(.system(size:40))
                
                TextField("Enter your full name", text:$firstname )
                    .padding()
                    .frame(width:550, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                    .font(.system(size: 20))
                    .padding()
                
                
                TextField("Enter your email address", text:$emailAddress )
                    .padding()
                    .frame(width: 550, height: 60, alignment: .center)
                    .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                    .font(.system(size: 20))
                    .padding()
                
                TextField("Enter your password", text:$password )
                    .padding()
                    .frame(width: 550, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black))
                    .font(.system(size: 20))
                    .padding()
                
                //Create account button
                Button(action:{
                    // do something - navigate to different screen
                }, label:{
                    Text("Create Account")
                        .fontWeight(.bold)
                        .font(.system(size: 21))
                        .frame(width:550, height:60, alignment: .center)
                        .background(Color("darkCyan"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                    
                })
                
                Text("or").font(.system(size:18))
                
                
                //Login with SSO Button
                Button(action:{
                    // do something - navigate to different screen
                }, label:{
                    Text("Login with SSO")
                        .fontWeight(.bold)
                        .font(.system(size: 21))
                        .frame(width:550, height:60, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 8.0).stroke(Color.black, lineWidth: 2.0))
                        .background(Color.white)
                        .foregroundColor(.black)
                        .padding()
                    
                })
                
                
            }
            
            Spacer()
        }
        
        
     
    }
    
}

//struct CreateButton: View{
//    var body: some View{
//        Text("Create Account")
//            .frame(width: 550, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .background(Color.pink)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            .padding()
//    }
//}



struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
