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
    private var listener: ListenerRegistration?

    @Published var groups: [Group] = []   // populated when changing Teams
    @Published var selectedGroup: Group?  // selected group in the listview

    @Published var msg = ""
    @Published var isShowingBanner = false
    @Published var didOperationSucceed = false
    @Published var groupMembers: [Member] = []
    @Published var nonMembers: [Member] = []

    func clear() {
        listener?.remove()
        groups = []
        selectedGroup = nil
        groupMembers = []
        nonMembers = []
    }

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
            "dateCreated": Date()
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

        listener = db.collection("teams").document(teamId).collection("groups").whereField("members", arrayContains: uid)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        // Add new item locally
                        do {
                            let newGroup = try (diff.document.data(as: Group.self)!)
                            self.groups.append(newGroup)
                        } catch {
                            print("Error reading new group from DB: \(error)")
                        }
                    }
                    if diff.type == .modified {
                        // Modify local item
                        do {
                            let mockGroup = try (diff.document.data(as: Group.self)!)
                            let docID = diff.document.documentID
                            let selectedGroupIndex = self.groups.firstIndex(where: {$0.groupId == docID})

                            self.groups[selectedGroupIndex!].groupTitle = mockGroup.groupTitle
                            self.groups[selectedGroupIndex!].members = mockGroup.members
                            self.groups[selectedGroupIndex!].admins = mockGroup.admins
                            self.groups[selectedGroupIndex!].sessions = mockGroup.sessions

                        } catch {
                            print("Error reading modified group from DB: \(error)")
                        }
                    }
                    if diff.type == .removed {
                        // Remove item locally
                        let selectedGroupId = diff.document.documentID
                        let selectedGroupIndex = self.groups.firstIndex(where: {$0.groupId == selectedGroupId})

                        if self.selectedGroup?.groupId == selectedGroupId {
                            self.selectedGroup = nil
                        }

                        self.groups.remove(at: selectedGroupIndex!)

                    }
                }
            }
    }

    func splitMembers(teamMembers: [Member]) {
        print("Team Members:", teamMembers)
        nonMembers = teamMembers
        groupMembers = teamMembers
        nonMembers.removeAll{
            selectedGroup!.members.contains($0.id)
        }
        groupMembers.removeAll {
            !selectedGroup!.members.contains($0.id)
        }

        print("Group Members:", groupMembers)
        print("Non Members:", nonMembers)
    }

    func addMembers(teamId: String?, memberIds: Set<String>) {
        let groupRef = db.collection("teams").document(teamId!).collection("groups").document(selectedGroup!.groupId)
        let newMemberIds = Array(memberIds)
        
        selectedGroup!.members += newMemberIds

        groupRef.updateData([
            "members": FieldValue.arrayUnion(newMemberIds)
        ]) { err in
            if let err = err {
                self.setBanner(message: "Error adding members: \(err)", didSucceed: false)
                print("Error adding members: \(err)")
            } else {
                self.setBanner(message: "Group Members Added Successfully", didSucceed: true)
                print("Members added to group successfully")
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
