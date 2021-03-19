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
        createSuccess = false
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
                    } else { // team created successfully
                        print("Document added with ID: \(ref!.documentID)")
                        self.createSuccess = true
                        self.msg = "Team created successfully"
                        
                        // Clean up text fields
                        self.newTeam.teamName = ""
                        self.newTeam.teamDescription = ""
                    }
                    withAnimation {
                        self.showBanner = true
                        self.delayAlert()
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
            
            if createSuccess {
                // add document ID to the user's team list
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
    
    func batchedCreateTeam() {
        
        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            createBanner(message: "Failed to find user ID", didSucceed: false)
            return
        }
        
        // Make sure Team Name is not empty
        guard !newTeam.teamName.isEmpty else {
            createBanner(message: "Team name must not be empty", didSucceed: false)
            return
        }
        
        // Attempt to save New Team to DB, and add Team reference to User document
        let batch = db.batch()
        
        let teamRef = db.collection("teams").document()
        batch.setData([
            "teamName": self.newTeam.teamName,
            "teamDescription": self.newTeam.teamDescription,
            "createdBy": uid,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid])
        ], forDocument: teamRef)
        
        let userRef = db.collection("users").document(uid)
        batch.updateData(["teams" : FieldValue.arrayUnion([teamRef.documentID])], forDocument: userRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch for Create Team: \(err)")
                self.createBanner(message: "Create Team failed. Try again.", didSucceed: false)
            } else {
                print("Team created successfully with id: \(teamRef.documentID)")
                self.createBanner(message: "Team created successfully!", didSucceed: true)
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
    
    private func createBanner(message: String, didSucceed: Bool) {
        msg = message
        createSuccess = didSucceed
        withAnimation {
            self.showBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.showBanner = false
                }
            }
        }
    }
    
}
