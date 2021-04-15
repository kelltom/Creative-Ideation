//
//  TeamViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-19.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

final class TeamViewModel: ObservableObject {

    private var db = Firestore.firestore()

    @Published var teams: [Team] = []   // populated when navigating to HomeView
    @Published var selectedTeam: Team?  // selected team in the sidebar
    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false
    @Published var teamCode = ""

    /// Creates a single team
    func createTeam(teamName: String, teamDescription: String) {

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            setBanner(message: "Failed to find user ID", didSucceed: false)
            return
        }

        // Populate Team object
        var newTeam = Team()
        newTeam.teamName = teamName
        newTeam.teamDescription = teamDescription

        // Make sure Team Name is not empty
        guard !newTeam.teamName.isEmpty else {
            setBanner(message: "Team name must not be empty", didSucceed: false)
            return
        }

        // Attempt to save New Team to DB, and add Team reference to User document
        let batch = db.batch()

        // Create randomly generated access code
        let accessCode = randomGen()

        let teamRef = db.collection("teams").document()
        batch.setData([
            "teamId": teamRef.documentID,
            "teamName": newTeam.teamName,
            "teamDescription": newTeam.teamDescription,
            "createdBy": uid,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid]),
            "accessCode": accessCode
        ], forDocument: teamRef)

        // let userRef = db.collection("users").document(uid)
        // batch.updateData(["teams": FieldValue.arrayUnion([teamRef.documentID])], forDocument: userRef)

        batch.commit { err in
            if let err = err {
                print("Error writing batch for Create Team: \(err)")
                self.setBanner(message: "Create Team failed. Try again.", didSucceed: false)
            } else {
                print("Team created successfully with id: \(teamRef.documentID)")
                self.setBanner(message: "Team created successfully!", didSucceed: true)
            }
        }

        // Reload list of teams
        getTeams()
    }

    // add users to team based on access code
    func joinTeam(code: String) {

        // get user id
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Could not find signed-in user's ID")
            return
        }
        //  get code of current team selected
        guard let currentTeamCode = selectedTeam?.accessCode else {
            print("no access code for this team")
            return
        }

        // Validation
        if code.isEmpty {
            self.setBanner(message: "Field cannot be empty. Please enter a code.", didSucceed: false)
            print("code is empty cant be empty")
        } else if currentTeamCode == code {
            self.setBanner(message: "Cannot join a team you are already in!", didSucceed: false)
            print("cant join an existing team")
        } else {
            // update members array in teams collection
            db.collection("teams").whereField("accessCode", isEqualTo: code)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        self.setBanner(message: "Error adding user to teams", didSucceed: false)
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if document.exists {
                                document.reference.updateData([
                                    "members": FieldValue.arrayUnion([uid])
                                ])
                                self.setBanner(message: "Successfully joined a team!", didSucceed: true)
                                print("Update team members successful")
                                self.getTeams()
                            } else {
                                self.setBanner(message: "Error in joining a team", didSucceed: true)
                                print("error in updating teams")
                            }
                        }
                    }
                }
        }
    }

    // Enables delete functionality on home view
    func deleteSelectedTeam(teamId: String?) {
        guard let teamId = teamId else {
            print("Delete Team: Selected Team ID not found")
            return
        }

        let team = teams.first(where: {$0.teamId == teamId})
        guard let createdBy = team?.createdBy else {
            print("Delete Team: Cannot find Team creator ID")
            return
        }

        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Delete Team: Current user not found")
            return
        }

        // Check if the user deleting the team is the same user who created - "only admin i guess"
        guard currentUserId == createdBy else {
            setBanner(message: "Access Denied. You do not have permission to delete this team.", didSucceed: false)
            print("Delete Team: User is not creator cannot delete")
            return
        }

        let batch = db.batch()

        // Delete Sessions
        db.collection("sessions").whereField("teamId", isEqualTo: teamId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            batch.deleteDocument(document.reference)
                        }
                    }
                }
            }

        // Delete groups
        db.collection("teams").document(teamId).collection("groups")
            .whereField("members", arrayContains: createdBy)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        batch.deleteDocument(document.reference)
                    }
                }
            }

        // Delete Actual Team
        let teamRef = db.collection("teams").document(teamId)
        batch.deleteDocument(teamRef)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            batch.commit { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                    self.getTeams()
                    self.selectedTeam = nil
                }
            }
        }
    }

    /// Populate list of teams associated with current user
    func getTeams() {

        // Empty list of teams to avoid repeated appends
        teams = []

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            // setBanner(message: "Failed to find user ID", didSucceed: false)
            return
        }

        // Query db to get references to all teams where current user's ID appears in members list
        // Create an instance of Team for each and add them to list of teams
        db.collection("teams").whereField("members", arrayContains: uid)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            // Convert document to Team object and append to list of teams
                            try self.teams.append(document.data(as: Team.self)!)
                            print("Team object added to list of teams successfully")
                        } catch {
                            print("Error adding team object to list of teams")
                        }

                    }
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


    // Generates a random code that can be used to join the team
    private func randomGen() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var code = ""
        for _ in 1...6 {
            code.append(letters.randomElement()!)
        }
        return code

    }

}
