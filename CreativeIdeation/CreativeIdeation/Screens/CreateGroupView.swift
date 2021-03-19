//
//  CreateGroupView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-25.
//

import SwiftUI

struct CreateGroupView: View {
    @State var groupName: String = ""
    @State var groupDescription: String = ""
    @State var groupMembers: String = ""
    @State var text: String = "" //search text
    
    
    var body: some View {
        VStack{
            Text("Create Your Group").font(.system(size: 40, weight: .heavy)).padding()
            HStack{
                
                VStack{
                    
                    MenuTextField(title: "group name", input: $groupName)
                    
                    MenuTextField(title: "group description (optiona)", input: $groupDescription)
                    
                    
                    Button{
                        // do something here
                    } label:{
                        BigButton(title: "Create").padding()
                    }
                    
                }
                
            }.padding() // padding padding for title
        }
    }
}






struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}


struct Student: Identifiable {
    var name: String
    var id = UUID()
}


