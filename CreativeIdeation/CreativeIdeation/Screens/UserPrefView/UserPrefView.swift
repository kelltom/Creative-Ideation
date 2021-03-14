//
//  UserPrefView.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-02-25.
//

import SwiftUI

struct UserPrefView: View {
    
    @State private var ttsOn = false
    @State private var profanityFilter = true
    @State private var ideaGen = true
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Text("User Preferences")
                    .font(.system(size: 48))
                    .fontWeight(.bold)
                    .padding()
                HStack{
                    Spacer()
                    ProfilePic(size: 150)
                        .padding()
                    VStack{
                        Spacer()
                        Button {
                            // do something - modify
                        } label: {
                            EditButton()
                        }
                    }
                    .frame(minHeight: 0, maxHeight: 150)
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        HStack(spacing: 40){
                            Text("Kellen Evoy")
                                .font(.system(size: 40))
                                .padding()
                            
                            Button{
                                // do something - modify
                            } label: {
                                EditButton()
                            }
                        }
                        HStack(spacing: 40){
                            Text("evoyk@sheridancollege.ca")
                                .font(.system(size: 40))
                                .padding()
                            
                            Button{
                                // do something - modify
                            } label: {
                                EditButton()
                            }
                        }
                        
                        Button{
                            //Change password
                        } label: {
                            BigButton(title: "Change Password")
                                .cornerRadius(15)
                                .padding()
                        }
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .padding()
            HStack{
                VStack{
                    Toggle("Enable Profanity Filter", isOn: $profanityFilter)
                        .font(.system(size: 28))
                        .padding()
                    
                    Toggle("Enable Text-to-Speech", isOn: $ttsOn)
                        .font(.system(size: 28))
                        .padding()
                    
                    Toggle("Enable Idea Generation", isOn: $ideaGen)
                        .font(.system(size: 28))
                        .padding()
                }
                .padding()
                
                VStack{
                    HStack(spacing: 0) {
                        Button {
                            // do something - navigate to different screen
                        } label: {
                            Text("Light Mode")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color("brandPrimary"))
                        }
                        Button {
                            // do something - navigate to different screen
                        } label: {
                            Text("Dark Mode")
                                .font(.title)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.white)
                        }

                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80)
                    .cornerRadius(45)
                    .overlay(RoundedRectangle(cornerRadius: 45) .stroke())
                    .padding()
                }
                .padding()
                
            }
            Spacer()
        }
    }
}

struct UserPrefView_Previews: PreviewProvider {
    static var previews: some View {
        UserPrefView()
    }
}
