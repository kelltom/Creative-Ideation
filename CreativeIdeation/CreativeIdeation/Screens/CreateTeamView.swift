//
//  CreateTeamsView.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-02-24.
//

import SwiftUI
import Firebase


struct CreateTeamView: View {
    
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
            
            if showBanner {
                NotificationBanner(image: bannerImage, msg: bannerMsg, color: bannerColor)
            }

            VStack {
                XDismissButton(isShowingSheet: $showCreateTeam)
                Spacer()
            }
            
            VStack {
                
                Text("Create Your Team")
                    .font(.system(size: 40))
                    .padding()
                
                VStack {
                    
                    MenuTextField(title: "Team name", input: $teamName)
                    
                    MenuTextField(title: "Team description (optional)", input: $teamDescription)
                    
                    Button {
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
                        
                    } label: {
                        BigButton(title: "Create")
                            .padding(.top, 5)
                    }
                    
                    Text("or")
                        .hidden()
                    
                    // Create Acc Button
                    NavigationLink(destination: EmptyView()) {
                        Text("Reactivate pre-existing team.")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    }
                    .padding(.top)
                    .hidden()
                    
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

struct CreateTeamView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTeamView(showCreateTeam: .constant(true), bannerMsg: "Success", bannerColor: .green, bannerImage: "checkmark.circle.fill")
    }
}
