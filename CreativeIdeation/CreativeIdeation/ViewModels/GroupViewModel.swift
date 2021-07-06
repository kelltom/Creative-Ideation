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

final class GroupViewModel: ObservableObject {

    private var db = Firestore.firestore()

    @Published var groups: [Group] = []   // populated when changing Teams
    @Published var selectedGroup: Group?  // selected group in the listview

    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false

    /// Creates a group within a Team with the given teamId
    func createGroup(teamId: String?, groupTitle: String) {

        // Get user id
        guard let uid = Auth.auth().currentUser?.uid else {
            setBanner(message: "Failed to find user ID", didSucceed: false)
            print("Failed to find user ID")
            return
        }

        // Check if uid is in admin list

        // Populate new Group object
        var group = Group()
        group.groupTitle = groupTitle

        // Check to make sure group name is not empty
        guard !group.groupTitle.isEmpty else {
            setBanner(message: "Group name must not be empty", didSucceed: false)
            print("Group name must not be empty")
            return
        }

        // Checks if teamid is nil
        guard let teamId = teamId else {
            setBanner(message: "Team ID not found, please try again", didSucceed: false)
            print("Error: Team ID is nil, cannot create Group")
            return
        }

        // Check if team id matches selected team , create group
        let teamRef = db.collection("teams").document(teamId)
        teamRef.getDocument {(document, _) in
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
            "groupTitle": group.groupTitle,
            "admins": FieldValue.arrayUnion([uid]),
            "members": FieldValue.arrayUnion([uid]),
            "sessions": FieldValue.arrayUnion([]),
            "dateCreated": FieldValue.serverTimestamp()
        ]) { err in
            if let err = err {
                self.setBanner(message: "Error adding document: \(err)", didSucceed: false)
                print("Error adding document: \(err)")
            } else {
                self.setBanner(message: "Group created successfully", didSucceed: true)
                print("Group document added successfully")
            }
        }

    }

    /// Populates list of groups within GroupViewModel according to given teamId
    func getGroups(teamId: String?) {

        // Empty list of groups to avoid repeated appends
        groups = []

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Failed to find user ID, cannot add Group to list")
            return
        }

        // Ensure Team ID is not nil
        guard let teamId = teamId else {
            print("Team ID is nil, cannot query Groups")
            return
        }

        // Query db to get references to all groups where current user's ID appears in members list
        // Create an instance of Group for each and add them to list of groups
        db.collection("teams").document(teamId).collection("groups").whereField("members", arrayContains: uid)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do {
                            // Convert document to Group object and append to list of teams
                            try self.groups.append(document.data(as: Group.self)!)
                            print("Group object added to list of groups successfully")
                        } catch {
                            print("Error adding group object to list of groups")
                        }

                    }
                    self.groups = self.groups.sorted(by: {
                        $0.dateCreated.compare($1.dateCreated) == .orderedAscending
                    })
                }
            }
    }

//    func getIdsNotInGroup(teamId: String) -> [String] {
//
//        var groupMemberIds: [String] = []
//        var teamMemberIds: [String] = []
//
//        guard let selectedGroup = selectedGroup else {
//            print("Selected Group is nil, cannot query Members")
//            return []
//        }
//
//        let groupDocRef = db.collection("teams").document(teamId).collection("groups").document(selectedGroup.groupId)
//        groupDocRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                if let gmIds = document.get("members") as? [String] {
//                    groupMemberIds = gmIds
//                }
//                print("Members array retrieved from selected group")
//            } else {
//                print("Document not found")
//                return
//            }
//        }
//
//        let teamDocRef = db.collection("teams").document(teamId)
//        teamDocRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                if let tmIds = document.get("members") as? [String] {
//                    teamMemberIds = tmIds
//                }
//                print("Members array retrieved from selected team")
//            } else {
//                print("Document not found")
//                return
//            }
//        }
//    }

//    func getMembersNotInGroup(teamId: String?) -> [Member] {
//        var members: [Member] = []
//
//        guard let teamId = teamId else {
//            print("Team ID is nil, cannot query Members")
//            return []
//        }
//
//
//        let memberIds = Array(Set(teamMemberIds).subtracting(groupMemberIds))
//
//        let userCollectionRef = db.collection("users")
//        var chunks: Int = memberIds.count / 10
//        let smallChunk = memberIds.count % 10
//        if smallChunk != 0 {
//            chunks += 1
//        }
//
//        var chunk = 0
//        var chunkMembers: [String] = []
//
//        print("Starting Chunk Loop")
//        while chunk < chunks {
//            if smallChunk != 0 && chunk == chunks - 1 {
//                chunkMembers = Array(memberIds[chunk*10...chunk*10+smallChunk])
//            } else {
//                chunkMembers = Array(memberIds[chunk*10...chunk*10+9])
//            }
//
//            print(chunkMembers)
//
//            userCollectionRef.whereField("id", in: chunkMembers)
//                .getDocuments { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else {
//                        for document in querySnapshot!.documents {
//                            do {
//                                // Convert document to Member object and append to list of team members
//                                try members.append(document.data(as: Member.self)!)
//                                print("Member object added to list of team members successfully")
//                            } catch {
//                                print("Error adding member to list of team members")
//                            }
//
//                        }
//                        members = members.sorted(by: {
//                            $0.name.compare($1.name) == .orderedAscending
//                        })
//                    }
//                }
//            chunk += 1
//        }
//
//        return members
//
//    }

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
