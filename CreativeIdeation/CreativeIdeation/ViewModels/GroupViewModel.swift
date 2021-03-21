//
//  GroupViewModel.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

final class GroupViewModel: ObservableObject{
    
    private var db = Firestore.firestore()
    
    @Published var groups: [Group] = []   // populated when navigating to HomeView
    @Published var selectedGroups: Group?  // selected team in the listview
    @Published var newGroup = Group()     // used by CreateTeamView
    
    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false
    
    /// Creates a group within a Team with the given teamId
    func createGroup(teamId: String?){
        
        // Get user id
        guard let uid = Auth.auth().currentUser?.uid else{
            setBanner(message: "Failed to find user ID", didSucceed: false)
            print("Failed to find user ID")
            return
        }
        
        // Check to make sure group name is not empty
        guard !newGroup.groupTitle.isEmpty else{
            setBanner(message: "Group name must not be empty", didSucceed: false)
            print("Group name must not be empty")
            return
        }
        
        
        // Checks if teamid is nil
        guard let teamId = teamId else{
            setBanner(message: "Team ID not found, please try again", didSucceed: false)
            print("Error: Team ID is nil, cannot create Group")
            return
        }
        
        // Check if team id matches selected team , create group
        let teamRef = db.collection("teams").document(teamId)
        teamRef.getDocument {(document, error) in
            if let document = document, document.exists {
                
            } else {
                self.setBanner(message: "Error: No Team selected, please try again", didSucceed: false)
                print("Error: Team document does not exist")
                return
            }
        }
        
        // Getting group document reference
        let groupRef = teamRef.collection("groups").document()
        
        // Adding group details to document
        groupRef.setData([
            "groupId": groupRef.documentID,
            "groupTitle": self.newGroup.groupTitle,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid])
        ]){ err in
            if let err = err {
                self.setBanner(message: "Error adding document: \(err)", didSucceed: false)
                print("Error adding document: \(err)")
            } else {
                self.setBanner(message: "Group created successfully", didSucceed: true)
                print("Group document added successfully")
                self.newGroup.groupTitle = ""
            }
        }
    }
    
    private func setBanner(message: String, didSucceed: Bool) {
        msg = message
        didOperationSucceed = didSucceed
        withAnimation {
            self.isShowingBanner = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    self.isShowingBanner = false
                }
            }
        }
    }
    
}
