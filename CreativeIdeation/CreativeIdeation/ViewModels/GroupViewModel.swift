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
    
    //create group
    func createGroup(teamId: String?){
        //get user id
        guard let uid = Auth.auth().currentUser?.uid else{
            setBanner(message: "Failed to find user ID", didSucceed: false)
            print("failed to find user ID")
            return
        }
        
        //check to make sure group name is not empty
        guard !newGroup.groupTitle.isEmpty else{
            setBanner(message: "Group Name must not be empty", didSucceed: false)
            print("group name must not be empty")
            return
        }
        
        
        //checks if teamid is nil
        guard let teamId = teamId else{
            setBanner(message: "Team Id is nil", didSucceed: false)
            print("no team id ")
            return
        }
        
        //check if team id matches selected team , create group
        let teamRef = db.collection("teams").document(teamId)
        teamRef.getDocument {(document, error) in
            if let document = document, document.exists {
                
            } else {
                self.setBanner(message: "team doc does not exists", didSucceed: false)
                print("team doc does not exists")
                return
            }
        }
        
        // getting group document reference
        let groupRef = teamRef.collection("groups").document()
        
        // adding group details to document
        groupRef.setData([
            "groupId": groupRef.documentID,
            "groupTitle": self.newGroup.groupTitle,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid])
        ]){
            err in
            if let err = err {
                self.setBanner(message: "Error adding document: \(err)", didSucceed: false)
                print("Error adding document: \(err)")
                
            } else {
                self.setBanner(message: "group doc added", didSucceed: true)
                print("group document successfully addedddddddd")
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
