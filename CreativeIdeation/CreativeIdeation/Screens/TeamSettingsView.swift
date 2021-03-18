//
//  TeamSettingsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct TeamSettingsView: View {
    
    @State private var profanityFilter = true
    
    var title: String = "Team Settings"
    var userName: String = "Kellen Evoy"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    
    var body: some View {
        
        VStack {
            
            Text(title)
                .font(.system(size: 40))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            
            VStack {
                
                Button{
                    //do stuff
                } label: {
                    PreferencePic().padding()
                }
                
                VStack(alignment: .leading ) {
                    
                    Text("Team Name")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                    
                    HStack {
                        
                        Text(userName)
                            .font(.system(size: 18))
                        
                        Spacer()
                        
                        Button {
                            //button functionality
                        } label: {
                            //button design
                            TextEditButton()
                        }
                    }
                    
                    Text("Description")
                        .font(.system(size: 25))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    HStack{
                        
                        Text(description)
                            .font(.system(size: 18))
                        
                        Spacer()
                        
                        Button {
                            //button functionality
                        } label: {
                            //button design
                            TextEditButton()
                        }
                        
                    }
                }
                .padding()
                .frame(minWidth:100,  maxWidth: 650, maxHeight: 340, alignment: .leading)
                .background(Color(.white))
                .cornerRadius(10)
                
            }
            .frame(maxWidth: 700, maxHeight: 500, alignment: .center)
            .background(Color("brandPrimary"))
            .cornerRadius(20)
            
            VStack(alignment: .leading) {
                
                Text("Profanity Control")
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                    .padding(.top)
                    .padding()
                
                HStack {
                    Toggle("Filter Specfic Words", isOn: $profanityFilter)
                        .padding()
                }
                
                HStack {
                    
                    Text("Blocked Words List")
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        //button functionality
                    } label: {
                        //button design
                        TextEditButton()
                    }
                }
                
            }
            .frame(maxWidth: 650, maxHeight: 230)
            
            Divider()
                .frame(maxWidth: 650).background(Color(.gray))
            
            Spacer()
            
            Button{
                //do something
            } label:{
                DeleteButton()
            }
            
        }
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView(title: "Title", userName: "Username", description: "Some description here")
    }
}
