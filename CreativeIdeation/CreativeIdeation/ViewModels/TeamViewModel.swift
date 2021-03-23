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
    @Published var newTeam = Team()     // used by CreateTeamView

    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false

    /// Creates a single team
    func createTeam() {

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            setBanner(message: "Failed to find user ID", didSucceed: false)
            return
        }

        // Make sure Team Name is not empty
        guard !newTeam.teamName.isEmpty else {
            setBanner(message: "Team name must not be empty", didSucceed: false)
            return
        }

        // Attempt to save New Team to DB, and add Team reference to User document
        let batch = db.batch()

        // Create randomly generated access code
        let code = randomGen()

        let teamRef = db.collection("teams").document()
        batch.setData([
            "teamId": teamRef.documentID,
            "teamName": self.newTeam.teamName,
            "teamDescription": self.newTeam.teamDescription,
            "createdBy": uid,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid]),
            "accessCode": code
        ], forDocument: teamRef)

        let userRef = db.collection("users").document(uid)
        batch.updateData(["teams": FieldValue.arrayUnion([teamRef.documentID])], forDocument: userRef)

        batch.commit { err in
            if let err = err {
                print("Error writing batch for Create Team: \(err)")
                self.setBanner(message: "Create Team failed. Try again.", didSucceed: false)
            } else {
                print("Team created successfully with id: \(teamRef.documentID)")
                self.setBanner(message: "Team created successfully!", didSucceed: true)
            }
        }

        // Reset input fields
        newTeam.teamName = ""
        newTeam.teamDescription = ""

        // Reload list of teams
        getTeams()
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
