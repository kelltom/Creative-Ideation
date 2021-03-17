//
//  TeamSettingsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-17.
//

import SwiftUI

struct TeamSettingsView: View {
    var userName: String = "Kellen Evoy"
    var description: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempo"
    
    var body: some View {
        VStack{
            //team image here
            GroupPic().padding()
            
            VStack(alignment: .leading ){
                Text("Team Name").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
                HStack{
                    Text(userName)
                     
                    Button{
                        //button functionality
                    }label:{
                        //button design
                        TextEditButton()
                    }
                }
                
                Text("Desctiption").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                HStack{
                    Text(description)
                     
                    Button{
                        //button functionality
                    }label:{
                        //button design
                        TextEditButton()
                    }
                }
            }
            .padding()
            .frame(minWidth:100,  maxWidth: 650, maxHeight: 350, alignment: .leading)
            .background(Color(.lightGray))
            .cornerRadius(10)
            
        }
        .frame(maxWidth: 700, maxHeight: 500, alignment: .center)
        .background(Color(.gray))
        .cornerRadius(20)
        
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView()
    }
}
