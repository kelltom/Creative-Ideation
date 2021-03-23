//
//  SessionViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class SessionViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    
    @Published var groupSessions: [Session] = []    /// List of Sessions from a group that the user belongs to
    @Published var teamSessions: [Session] = []     /// List of Sessions from a team that the user belongs to, sorted by dateModified
    @Published var selectedSession: Session?        /// Session object of the selected Session
    @Published var newSession = Session()           /// Session object used when creating new Sessions, binds to UI
    
    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false

    /// Creates a Session within a Group with the given groupId
    func createSession(teamId: String?, groupId: String?) {
        // This needs to be a batched write. We are writing to both the Group document, and the Session document - adding either ID to either document as foreign keys.
        
        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            //setBanner(message: "Failed to find user ID", didSucceed: false)
            print("Failed to find user ID")
            return
        }
        
        //Check to make sure session name is not empty
        guard !newSession.sessionTitle.isEmpty else {
            print("Session title cannot be empty")
            return
        }
        
        // Check if group is nil - session must belong to a group
        guard let groupId = groupId else {
            print("groupID is nil - cannot create session")
            return
        }
        
        // Check if team is nil - group must belong to a team
        guard let teamId = teamId else {
            print("teamID is nil - cannot create session")
            return
        }
        
        // Save new session to DB - using batch
        let sessionRef = db.collection("sessions").document()
        let batch = db.batch()
        batch.setData([
            "sessionId": sessionRef.documentID,
            "createdBy": uid,
            "description": self.newSession.sessionDescription,
            "groupId": groupId,
            "inProgress": "",
            "title": self.newSession.sessionTitle,
            "type": ""
        ], forDocument: sessionRef)
        
        // Save Session ID to list of Sessions in Group document
        let groupRef = db.collection("teams").document(teamId).collection("groups").document(groupId)
        batch.updateData([
            "sessions": FieldValue.arrayUnion([sessionRef.documentID])
        ], forDocument: groupRef)
        
        // Commit
        batch.commit() { err in
            if let err = err {
                print("Error writing batch for Create Session: \(err)")
                //self.setBanner(message: "Create Session failed. Try again.", didSucceed: false)
            } else {
                print("Session created successfully with id: \(sessionRef.documentID)")
                //self.setBanner(message: "Session created successfully!", didSucceed: true)
            }
        }
    }
    
    /// Populates teamSessions array, storing a Session object for each found in the datastore
    func getAllSessions(teamId: String?) {
    
    }
    
    /// Populates groupSessions array, storing a Session object for each found in the datastore
    func getGroupSessions(groupId: String?) {
        
    }
    
    
   
    
    
}
