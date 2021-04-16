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
    @Published var teamSessions: [Session] = []     /// List of Sessions from a team that the user belongs to
    @Published var selectedSession: Session?        /// Session object of the selected Session
    @Published var newSession = Session()           /// Session object used when creating new Sessions, binds to UI

    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false

    /// Creates a Session within a Group with the given groupId
    func createSession(teamId: String?, groupId: String?) {
        // This needs to be a batched write. We are writing to both the Group document,
        // and the Session document - adding either ID to either document as foreign keys.

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            // setBanner(message: "Failed to find user ID", didSucceed: false)
            print("Failed to find user ID")
            return
        }

        // Check to make sure session name is not empty
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
        newSession.sessionId = sessionRef.documentID

        let batch = db.batch()
        batch.setData([
            "sessionId": sessionRef.documentID,
            "sessionTitle": self.newSession.sessionTitle,
            "sessionDescription": self.newSession.sessionDescription,
            "type": "",
            "inProgress": true,
            "dateCreated": FieldValue.serverTimestamp(),
            "dateModified": "",  // should get timestamp
            "createdBy": uid,
            "groupId": groupId,
            "teamId": teamId
        ], forDocument: sessionRef)

        // Save Session ID to list of Sessions in Group document
        let groupRef = db.collection("teams").document(teamId).collection("groups").document(groupId)
        batch.updateData([
            "sessions": FieldValue.arrayUnion([sessionRef.documentID])
        ], forDocument: groupRef)

        // Commit
        batch.commit { err in
            if let err = err {
                print("Error writing batch for Create Session: \(err)")
                // self.setBanner(message: "Create Session failed. Try again.", didSucceed: false)
            } else {
                print("Session created successfully with id: \(sessionRef.documentID)")
                // self.setBanner(message: "Session created successfully!", didSucceed: true)
            }
        }
    }

    /// Populates teamSessions array, storing a Session object for each found in the datastore
    func getAllSessions(teamId: String?) {
        // Empty list of sessions
        teamSessions = []

        // Ensure Team ID is not nil
        guard let teamId = teamId else {
            print("Cannot get Sessions: Team ID is nil")
            return
        }

        // Get list of Sessions that belong to Team ID
        db.collection("sessions").whereField("teamId", in: [teamId])
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting Session: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            // Convert document to Session object and append to list of teamSessions
                            try self.teamSessions.append(document.data(as: Session.self)!)
                            print("Session object added to list of teamSessions")
                        } catch {
                            print("Error adding Session object to list of teamSessions")
                        }
                    }
                    self.teamSessions = self.teamSessions.sorted(by: {
                        $0.dateCreated.compare($1.dateCreated) == .orderedDescending
                    })
                }
            }
    }

    /// Populates groupSessions array, storing a Session object for each found in the datastore
    func getGroupSessions(groupId: String?) {
        // Empty list of sessions
        groupSessions = []

        // Ensure Group ID is not nil
        guard let groupId = groupId else {
            print("Cannot get Sessions: Group ID is nil")
            return
        }

        // Get list of Sessions that belong to Group ID
        db.collection("sessions").whereField("groupId", in: [groupId])
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting Session: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            // Convert document to Session object and append to list of groupSessions
                            try self.groupSessions.append(document.data(as: Session.self)!)
                            print("Session object added to list of groupSessions")
                        } catch {
                            print("Error adding Session object to list of groupSessions")
                        }
                    }
                    self.groupSessions = self.groupSessions.sorted(by: {
                        $0.dateCreated.compare($1.dateCreated) == .orderedDescending
                    })
                }
            }
    }
}
