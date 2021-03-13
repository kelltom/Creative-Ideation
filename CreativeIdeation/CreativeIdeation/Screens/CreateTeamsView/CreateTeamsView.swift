//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI
import Firebase


struct CreateTeamsView: View {
    @State var teamName: String = ""
    @State var teamDescripton: String = ""
    @State var teamMembers: String = ""
    
    // db init
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    
    var body: some View {
        
        VStack{
            
            Text("Create Your Team").font(.system(size: 40, weight: .heavy)).padding()
            
            VStack{
                MenuTextField(title: "team name", input: $teamName)
                
                MenuTextField(title: "team description (optiona)", input: $teamDescripton)
                
//                MenuTextField(title: "enter team members", input: $teamMembers)
//
//                ScrollView(.horizontal){
//                    LazyHStack{
//                        AddUserPanel()
//                        AddUserPanel()
//                        AddUserPanel()
//                        AddUserPanel()
//                        AddUserPanel()
//                        AddUserPanel()
//                        AddUserPanel()
//                        AddUserPanel()
//
//                    }
//
//                }
//                .frame(width: 550, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .leading)
//
                Button{
                    // do something here
                    var ref: DocumentReference? = nil
                    
                    ref = db.collection("teams").addDocument(data: [
                        "teamName": $teamName,
                        "teamDescription": $teamDescripton,
                        "createdBy": user?.uid
                        
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                        }
                    }
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
