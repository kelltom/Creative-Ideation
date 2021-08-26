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

    @Published var groupMembers: [Member] = []
    @Published var nonMembers: [Member] = []
    @Published var wasCreateSuccess: Bool = false  // indicates Group was successfully created

    @Published var showBanner = false
    @Published var bannerData: BannerModifier.BannerData =
        BannerModifier.BannerData(title: "Default Title",
                                  detail: "Default detail message.",
                                  type: .info)

    func clear() {
        listener?.remove()
        groups = []
        selectedGroup = nil
        groupMembers = []
        nonMembers = []
        showBanner = false
        wasCreateSuccess = false
    }

    /// Creates a group within a Team with the given teamId
    func createGroup(teamId: String?, groupTitle: String) {

        // Get user id
        guard let uid = Auth.auth().currentUser?.uid else {
            // Set banner
            self.setBannerData(title: "Cannot create Group",
                               details: "Failed to find user ID. Make sure you are connected to the internet and try again.",
                               type: .warning)
            self.showBanner = true

            print("Failed to find user ID")
            return
        }

        // Check if uid is in admin list

        // Populate new Group object
        var group = Group()
        group.groupTitle = groupTitle

        // Check to make sure group name is not empty
        guard !group.groupTitle.isEmpty else {
            // Set banner
            self.setBannerData(title: "Cannot create Group",
                               details: "Group name must not be empty.",
                               type: .warning)
            self.showBanner = true

            print("createGroup: Group name must not be empty")
            return
        }

        // Checks if teamid is nil
        guard let teamId = teamId else {
            // Set banner
            self.setBannerData(title: "Cannot create Group",
                               details: "No ID found for selected Team. Make sure you have a Team selected.",
                               type: .warning)
            self.showBanner = true
            print("createGroup: Team ID is nil, cannot create Group")
            return
        }

        // Check if team id matches selected team , create group
        let teamRef = db.collection("teams").document(teamId)
        teamRef.getDocument {(document, _) in
            if let document = document, document.exists {

            } else {
                // Set banner
                self.setBannerData(title: "Cannot create Group",
                                   details: "Selected Team ID not found in our database. Team may no longer exist. Wait a few seconds and try again.",
                                   type: .warning)
                self.showBanner = true

                print("createGroup: Team document does not exist")
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
                // Set banner
                self.setBannerData(title: "Create Group failed",
                                   details: "Error: \(err.localizedDescription). Wait a few seconds and try again.",
                                   type: .error)
                self.showBanner = true

                print("createGroup: Error adding document: \(err)")
            } else {
                // Set banner
                self.setBannerData(title: "Success",
                                   details: "Group created successfully!",
                                   type: .success)
                self.showBanner = true

                self.wasCreateSuccess = true

                print("createGroup: Group document added successfully")
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

    /// Determines if current user is an admin of the selected Group
    func isCurrentUserAdmin(groupId: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("isCurrentUserAdmin: Cannot find uid.")
            return false  // should probably throw error here
        }

        guard let index = groups.firstIndex(where: {$0.groupId == groupId}) else {
            print("isCurrentUserAdmin: Cannot find index of selected group.")
            return false
        }

        let group = groups[index]

        return group.admins.contains(uid)
    }

    func splitMembers(teamMembers: [Member]) {
        nonMembers = teamMembers
        groupMembers = teamMembers
        nonMembers.removeAll {
            selectedGroup!.members.contains($0.id)
        }
        groupMembers.removeAll {
            !selectedGroup!.members.contains($0.id)
        }
    }

    func addMembers(teamId: String?, memberIds: Set<String>) {
        let groupRef = db.collection("teams").document(teamId!).collection("groups").document(selectedGroup!.groupId)
        let newMemberIds = Array(memberIds)

        selectedGroup!.members += newMemberIds

        groupRef.updateData([
            "members": FieldValue.arrayUnion(newMemberIds)
        ]) { err in
            if let err = err {
                // Set banner
                self.setBannerData(title: "Failed to add members",
                                   details: "Error: \(err.localizedDescription).",
                                   type: .error)
                self.showBanner = true

                print("addMembers: Error adding members: \(err)")
            } else {
                if self.wasCreateSuccess {
                    // If team was just created, don't show banner and set creation flag false
                    self.wasCreateSuccess = false
                } else {
                    // Set banner
                    self.setBannerData(title: "Success",
                                       details: "Group members added successfully.",
                                       type: .success)
                    self.showBanner = true
                }

                print("addMembers: Members added to group successfully")
            }
        }

    }

    /// Assigns values to the published BannerData object
    private func setBannerData(title: String, details: String, type: BannerModifier.BannerType) {
        bannerData.title = title
        bannerData.detail = details
        bannerData.type = type
    }
}
