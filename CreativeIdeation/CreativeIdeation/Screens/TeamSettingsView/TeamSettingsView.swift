//
//  TeamSettingsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct TeamSettingsView: View {
    var userName: String = "Kellen Evoy"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
    @State private var profanityFilter = true
    
    var body: some View {
        VStack {
            VStack{
                //team image here
                GroupPic().padding()
                
                VStack(alignment: .leading ){
                    Text("Team Name")
                        .font(.system(size: 20))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    HStack{
                        Text(userName)
                            .font(.system(size: 18))
                        
                        Spacer()
                        
                        Button{
                            //button functionality
                        }label:{
                            //button design
                            TextEditButton()
                        }
                    }
                    
                    Text("Description")
                        .font(.system(size: 20))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    HStack{
                        Text(description)
                            .font(.system(size: 18))
                        Spacer()
                        Button{
                            //button functionality
                        }label:{
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
            
            VStack(alignment: .leading){
                Text("Profanity Control")
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.gray)
                    .padding()
                
                HStack{
                    Toggle("Filter Specfic Wods", isOn: $profanityFilter)
                        .padding()
                        
                }
                
                HStack{
                    Text("Blocked Words List")
                        .padding()
                    Spacer()
                    Button{
                        //button functionality
                    }label:{
                        //button design
                        TextEditButton()
                    }
                }
               
            }
            .frame(maxWidth: 650, maxHeight: 300)
            Divider().frame(maxWidth: 650)
            
        }
                
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView()
    }
}
