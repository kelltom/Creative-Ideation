//
//  TeamViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-19.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFunctions
import SwiftUI

final class TeamViewModel: ObservableObject {

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    @Published var teams: [Team] = []   // populated when navigating to HomeView
    @Published var selectedTeam: Team?  // selected team in the sidebar
    @Published var teamCode = ""
    @Published var teamMembers: [Member] = []

    @Published var didCreateSuccess: Bool = false  // toggles when Team is created
    @Published var newTeamId: String = ""  // ID of the most recent created Team

    @Published var showBanner = false
    @Published var bannerData: BannerModifier.BannerData =
        BannerModifier.BannerData(title: "Default Title",
                                  detail: "Default detail message.",
                                  type: .info)

    // Update selected team when user makes a selection
    func selectTeam(team: Team) {
        selectedTeam = team
        loadMembers()
    }

    // Load Members of the selected team
    func loadMembers() {
        teamMembers = []

        guard let selectedTeam = selectedTeam else {
            print("selectedTeam is nil, cannot query Members")
            return
        }

        let userCollectionRef = db.collection("users")
        var chunks: Int = selectedTeam.members.count / 10
        let smallChunk = selectedTeam.members.count % 10
        if smallChunk != 0 {
            chunks += 1
        }

        var chunk = 0
        var chunkMembers: [String] = []

        while chunk < chunks {
            if smallChunk != 0 && chunk == chunks - 1 {
                chunkMembers = Array(selectedTeam.members[chunk*10...chunk*10+smallChunk-1])
            } else {
                chunkMembers = Array(selectedTeam.members[chunk*10...chunk*10+9])
            }

            print(chunkMembers)

            userCollectionRef.whereField("id", in: chunkMembers)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                // Convert document to Member object and append to list of team members
                                try self.teamMembers.append(document.data(as: Member.self)!)
                            } catch {
                                print("Error adding member to list of team members")
                            }

                        }
                        self.teamMembers = self.teamMembers.sorted(by: {
                            $0.name.compare($1.name) == .orderedAscending
                        })
                    }
                }
            chunk += 1
        }
    }

    /// Returns a list of Member objects belonging to the selected Team
    func getTeamMembers(includeCurrentUser: Bool = true) -> [Member] {
        var members = self.teamMembers

        if !includeCurrentUser {
            // get user id
            guard let uid = Auth.auth().currentUser?.uid else {
                print("getTeamMembers: Could not find signed-in user's ID")
                return []
            }

            if let index = members.firstIndex(where: {$0.id == uid}) { // find index of current user
                members.remove(at: index)
            }
        }

        return members
    }

    /// Creates a single team
    func createTeam(teamName: String, teamDescription: String, isPrivate: Bool = false) {

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            // Set banner
            self.setBannerData(title: "Cannot create Team",
                               details: "Failed to find user ID. Make sure you are connected to the internet and try again.",
                               type: .error)
            self.showBanner = true
            return
        }

        // Populate Team object
        var newTeam = Team()
        newTeam.teamName = teamName
        newTeam.teamDescription = teamDescription
        newTeam.isPrivate = isPrivate

        // Make sure Team Name is not empty
        guard !newTeam.teamName.isEmpty else {
            // Set banner
            self.setBannerData(title: "Cannot create Team",
                               details: "Team name must not be empty.",
                               type: .warning)
            self.showBanner = true
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
            "isPrivate": newTeam.isPrivate,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid]),
            "accessCode": accessCode,
            "dateCreated": Date()
        ], forDocument: teamRef)

        // let userRef = db.collection("users").document(uid)
        // batch.updateData(["teams": FieldValue.arrayUnion([teamRef.documentID])], forDocument: userRef)

        batch.commit { err in
            if let err = err {
                print("Error writing batch for Create Team: \(err)")
                // Set banner
                self.setBannerData(title: "Cannot create Team",
                                   details: "Something went wrong on our end. Wait a few seconds and try again.",
                                   type: .warning)
                self.showBanner = true
            } else {
                print("Team created successfully with id: \(teamRef.documentID)")

                if !newTeam.isPrivate {
                    // Set banner
                    self.setBannerData(title: "Success",
                                       details: "Team created successfully!",
                                       type: .success)
                    self.showBanner = true

                    self.newTeamId = teamRef.documentID

                    self.didCreateSuccess = true
                }
            }
        }
    }

    // Add users to team based on access code
    func joinTeam(code: String) {

        // get user id
        guard let uid = Auth.auth().currentUser?.uid else {
            print("joinTeam: Could not find signed-in user's ID")
            return
        }
        //  get code of current team selected
//        guard let currentTeamCode = selectedTeam?.accessCode else {
//            print("no access code for this team")
//            return
//        }

        // Validation
        if code.isEmpty {
            // Set banner
            self.setBannerData(title: "Cannot join Team",
                               details: "Field cannot be empty. Please enter a code.",
                               type: .warning)
            self.showBanner = true
//        } else if currentTeamCode == code {
//            self.setBanner(message: "Cannot join a team you are already in!", didSucceed: false)
//            print("cant join an existing team")
        } else {
            // Update members array in teams collection
            db.collection("teams").whereField("accessCode", isEqualTo: code)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        // Set banner
                        self.setBannerData(title: "Cannot join team",
                                           details: "We've encountered an error trying to add user to the Team. Make sure you're connected to the internet and try again.",
                                           type: .error)
                        self.showBanner = true

                        print("joinTeam: Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            if document.exists {

                                document.reference.updateData([
                                    "members": FieldValue.arrayUnion([uid])
                                ])

                                document.reference.collection("groups").whereField("isPublic", isEqualTo: true).getDocuments { (querySnapshot, err) in
                                        if let err = err {
                                            print("addIdToPublic: Error getting documents: \(err)")
                                        } else {
                                            for document in querySnapshot!.documents {
                                                if document.exists {
                                                    document.reference.updateData([
                                                        "members": FieldValue.arrayUnion([uid])
                                                    ])

                                                    print("addIdToPublic: Added to Public Group successfully.")
                                                } else {

                                                    print("addIdToPublic: Error accessing Group document. Document likely no longer exists.")
                                                }
                                            }
                                        }
                                }

                                // Set banner
                                self.setBannerData(title: "Success",
                                                   details: "Successfully joined a Team!",
                                                   type: .success)
                                self.showBanner = true

                                print("Update team members successful")
                            } else {
                                // Set banner
                                self.setBannerData(title: "Cannot join team",
                                                   details: "Cannot find Team in our database. This Team has likely been deleted.",
                                                   type: .error)
                                self.showBanner = true

                                print("joinTeam: Error accessing Team document. Document likely no longer exists.")
                            }
                        }
                    }
                }
        }
    }

    private func addIdToPublic(ref: DocumentReference) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("addIdToPublic: Cannot get UID.")
            return
        }

        ref.collection("groups").whereField("isPublic", isEqualTo: true).getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("addIdToPublic: Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if document.exists {
                            document.reference.updateData([
                                "members": FieldValue.arrayUnion([uid])
                            ])

                            print("addIdToPublic: Added to Public Group successfully.")
                        } else {

                            print("addIdToPublic: Error accessing Group document. Document likely no longer exists.")
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
            // Set banner
            self.setBannerData(title: "Cannot delete Team",
                               details: "Access Denied. You do not have permission to delete this team.",
                               type: .warning)
            self.showBanner = true
            print("Delete Team: User is not creator of Team, so they cannot delete it.")
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
                    self.selectedTeam = nil

                    // Set banner
                    self.setBannerData(title: "Success",
                                       details: "The Team has been deleted.",
                                       type: .success)
                    self.showBanner = true
                }
            }
        }
    }

    /// Populate list of teams associated with current user
    func getTeams() {

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            // setBanner(message: "Failed to find user ID", didSucceed: false)
            return
        }

        listener = db.collection("teams").whereField("members", arrayContains: uid)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        // Add new item locally
                        do {
                            let newTeam = try (diff.document.data(as: Team.self)!)
                            self.teams.append(newTeam)
                        } catch {
                            print("Error reading new team from DB: \(error)")
                        }
                    }
                    if diff.type == .modified {
                        // Modify local item
                        do {
                            let mockTeam = try (diff.document.data(as: Team.self)!)
                            let docID = diff.document.documentID
                            let selectedTeamIndex = self.teams.firstIndex(where: {$0.teamId == docID})

                            self.teams[selectedTeamIndex!].teamName = mockTeam.teamName
                            self.teams[selectedTeamIndex!].teamDescription = mockTeam.teamDescription
                            self.teams[selectedTeamIndex!].isPrivate = mockTeam.isPrivate
                            self.teams[selectedTeamIndex!].members = mockTeam.members
                            self.teams[selectedTeamIndex!].admins = mockTeam.admins

                        } catch {
                            print("Error reading modified team from DB: \(error)")
                        }
                    }
                    if diff.type == .removed {
                        // Remove item locally
                        let selectedTeamId = diff.document.documentID
                        let selectedTeamIndex = self.teams.firstIndex(where: {$0.teamId == selectedTeamId})

                        if self.selectedTeam?.teamId == selectedTeamId {
                            self.selectedTeam = nil
                        }

                        self.teams.remove(at: selectedTeamIndex!)

                    }
                }
            }
    }

    func clear() {
        listener?.remove()
        teams = []
        selectedTeam = nil
        showBanner = false
        teamCode = ""
        didCreateSuccess = false
        newTeamId = ""
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

    /// Assigns values to the published BannerData object
    private func setBannerData(title: String, details: String, type: BannerModifier.BannerType) {
        bannerData.title = title
        bannerData.detail = details
        bannerData.type = type
    }

}
