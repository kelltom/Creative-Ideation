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
    private var listener: ListenerRegistration?

    @Published var selectedGroupId: String?
    @Published var groupSessions: [Session] = []    /// List of Sessions from a group that the user belongs to
    @Published var teamSessions: [Session] = []     /// List of Sessions from a team that the user belongs to
    @Published var selectedSession: Session?        /// Session object of the selected Session
    @Published var newSession = Session()           /// Session object used when creating new Sessions, binds to UI

    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false

    func clear() {
        teamSessions = []
        groupSessions = []
        selectedSession = nil
        selectedGroupId = nil
        listener?.remove()
    }

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
            "isVoting": false,
            "dateCreated": Date(),
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

        // Ensure Team ID is not nil
        guard let teamId = teamId else {
            print("Cannot get Sessions: Team ID is nil")
            return
        }

        listener = db.collection("sessions").whereField("teamId", in: [teamId])
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        // Add new session locally
                        do {
                            let newSession = try (diff.document.data(as: Session.self)!)
                            self.teamSessions.append(newSession)
                            if newSession.groupId == self.selectedGroupId {
                                self.groupSessions.append(newSession)
                            }
                        } catch {
                            print("Error reading new session from DB: \(error)")
                        }
                    }
                    if diff.type == .modified {
                        // Modify local session
                        do {
                            let mockSession = try (diff.document.data(as: Session.self)!)
                            let docID = diff.document.documentID
                            let selectedSessionIndex = self.teamSessions.firstIndex(where: {$0.sessionId == docID})

                            self.teamSessions[selectedSessionIndex!].sessionTitle = mockSession.sessionTitle
                            self.teamSessions[selectedSessionIndex!].sessionDescription = mockSession.sessionDescription
                            self.teamSessions[selectedSessionIndex!].inProgress = mockSession.inProgress
                            self.teamSessions[selectedSessionIndex!].isVoting = mockSession.isVoting
                            self.teamSessions[selectedSessionIndex!].dateModified = mockSession.dateModified

                            let selectedSessionGroupIndex = self.groupSessions.firstIndex(where: {$0.sessionId == mockSession.sessionId})
                            if selectedSessionGroupIndex != nil {
                                self.groupSessions[selectedSessionGroupIndex!].sessionTitle = mockSession.sessionTitle
                                self.groupSessions[selectedSessionGroupIndex!].sessionDescription = mockSession.sessionDescription
                                self.groupSessions[selectedSessionGroupIndex!].inProgress = mockSession.inProgress
                                self.groupSessions[selectedSessionGroupIndex!].dateModified = mockSession.dateModified
                            }

                        } catch {
                            print("Error reading modified session from DB: \(error)")
                        }
                    }
                    if diff.type == .removed {
                        // Remove session locally
                        let selectedSessionId = diff.document.documentID
                        let selectedSessionIndex = self.teamSessions.firstIndex(where: {$0.sessionId == selectedSessionId})

                        if self.selectedSession?.sessionId == selectedSessionId {
                            self.selectedSession = nil
                        }

                        self.teamSessions.remove(at: selectedSessionIndex!)

                        let selectedSessionGroupIndex = self.groupSessions.firstIndex(where: {$0.sessionId == selectedSessionId})
                        if selectedSessionGroupIndex != nil {
                            self.groupSessions.remove(at: selectedSessionGroupIndex!)
                        }

                    }
                }
            }
    }

    /// Populates groupSessions array, storing a Session object for each found in the datastore
    func getGroupSessions() {
        // Empty list of sessions
        groupSessions = []

        // Ensure Group ID is not nil
        guard let selectedGroupId = selectedGroupId else {
            print("Cannot get Sessions: Group ID is nil")
            return
        }

        for session in teamSessions.filter({$0.groupId == selectedGroupId}) {
                groupSessions.append(session)
        }
    }
}
