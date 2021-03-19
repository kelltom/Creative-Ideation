//
//  TeamViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-19.
//

import Foundation
import Firebase
import SwiftUI

final class TeamViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    let user = Auth.auth().currentUser
    
    @Published var teams: [Team] = []   // populated when navigating to HomeView
    @Published var selectedTeam: Team?  // selected team in the sidebar
    @Published var newTeam = Team()     // used by CreateTeamView
    
    @Published var createSuccess = false
    @Published var msg = ""
    @Published var showBanner = false
    
    func createTeam() {
        // Attempt to save new Team to db
        var ref: DocumentReference? = nil
        let userId: String = user?.uid ?? ""
        
        if !userId.isEmpty {
            
            if !newTeam.teamName.isEmpty {
                ref = db.collection("teams").addDocument(data: [
                    "teamName": self.newTeam.teamName,
                    "teamDescription": self.newTeam.teamDescription,
                    "createdBy": userId,
                    "admins": FieldValue.arrayUnion([userId]),
                    "members": FieldValue.arrayUnion([userId])
                ]) { err in
                    if let err = err { // failed to add team document
                        print("Error adding document: \(err)")
                        self.createSuccess = false
                        self.msg = "Error creating team: \(err)"
                        withAnimation {
                            self.showBanner = true
                            self.delayAlert()
                        }
                    } else { // team created successfully
                        self.createSuccess = true
                        self.msg = "Team created successfully"
                        withAnimation {
                            self.showBanner = true
                            self.delayAlert()
                        }
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            } else { // if team name is missing
                self.createSuccess = false
                self.msg = "Team name is required"
                withAnimation {
                    self.showBanner = true
                    self.delayAlert()
                }
            }
            
        } else { // if user ID not found
            self.msg = "Error: User ID not found"
            self.createSuccess = false
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
        }
    }
    
    // Tells View to stop showing banner after 4 seconds
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                self.showBanner = false
            }
        }
    }
    
}
