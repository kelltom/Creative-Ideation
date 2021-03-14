//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI
import Firebase


struct CreateTeamsView: View {
    
    @State private var showBanner: Bool = false
    @Binding var showCreateTeam: Bool
    
    @State var teamName: String = ""
    @State var teamDescription: String = ""
    @State var teamMembers: String = ""
    
    @State var bannerMsg: String
    @State var bannerColor: Color
    @State var bannerImage: String
    
    // db init
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    var body: some View {
        
        ZStack {
            
            if showBanner{
                NotificationBanner(image: bannerImage, msg: bannerMsg, color: bannerColor)
            }
            NotificationBanner(image: bannerImage, msg: bannerMsg, color: bannerColor)

            VStack {
                XDismissButton(isShowingSheet: $showCreateTeam)
                Spacer()
            }
            
            VStack{
                
                Text("Create Your Team")
                    .font(.system(size: 40, weight: .heavy))
                    .padding()
                
                VStack{
                    
                    MenuTextField(title: "team name", input: $teamName)
                    
                    MenuTextField(title: "team description (optiona)", input: $teamDescription)
                    
                    Button{
                        // Display error message when no Team name entered
                        if (teamName.isEmpty){
                            
                            bannerMsg = "Missing Team Name"
                            bannerColor = Color.red
                            bannerImage = "exclamationmark.circle.fill"
                            
                            withAnimation {
                                showBanner = true
                            }
                            delayAlert()
                            
                        } else {
                            // Attempt to save new Team to db
                            var ref: DocumentReference? = nil
                            
                            ref = db.collection("teams").addDocument(data: [
                                "teamName": teamName,
                                "teamDescription": teamDescription,
                                "createdBy": user?.uid as Any
                            ]) { err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    bannerMsg = "Success"
                                    bannerColor = Color.green
                                    bannerImage = "checkmark.circle.fill"
                                    
                                    withAnimation {
                                        showBanner = true
                                    }
                                    delayAlert()
                                    
                                    print("Document added with ID: \(ref!.documentID)")
                                }
                            }
                        }
                        
                    } label:{
                        BigButton(title: "Create")
                            .padding()
                    }
                    
                    Text("or")
                        .font(.system(size:18))
                    
                    Button{
                        // do something here
                    } label:{
                        BigButton(title: "Start Session")
                            .padding()
                    }
                    
                }
            }
        }
        
    }
    
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation{
                showBanner = false
            }
        }
    }
}

struct CreateTeamsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamsView(showCreateTeam: .constant(true), bannerMsg: "Success", bannerColor: .green, bannerImage: "checkmark.circle.fill")
    }
}
