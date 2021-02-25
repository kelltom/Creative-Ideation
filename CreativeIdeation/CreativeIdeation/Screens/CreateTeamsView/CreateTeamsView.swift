//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI

struct CreateTeamsView: View {
    @State var teamName: String = ""
    @State var teamDescripton: String = ""
    @State var teamMembers: String = ""
    
    
    var body: some View {
        VStack{
            Text("Create Your Team").font(.system(size: 40, weight: .heavy)).padding()
            
            VStack{
                MenuTextField(title: "team name", input: $teamName)
                
                MenuTextField(title: "team description (optiona)", input: $teamMembers)
                
                MenuTextField(title: "enter team members", input: $teamMembers)
                
                Button{
                    // do something here
                } label:{
                    BigButton(title: "Create").padding()
                }
                Text("or").font(.system(size:18))
                
                Button{
                    // do something here
                } label:{
                    BigButton(title: "Start Session").padding()
                }
                
            }
        }
    }
}








struct CreateTeamsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamsView()
    }
}
