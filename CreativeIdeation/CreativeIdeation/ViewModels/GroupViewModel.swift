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
import Profanity_Filter

final class GroupViewModel: ObservableObject {

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var pFilter = ProfanityFilter()

    @Published var groups: [Group] = []   // populated when changing Teams
    @Published var selectedGroup: Group?  // selected group in the listview
    @Published var groupMembers: [Member] = []
    @Published var nonMembers: [Member] = []
    @Published var wasCreateSuccess: Bool = false  // indicates Group was successfully created
    @Published var isLoading = false

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

    func setSelectedGroup(group: Group) {
        self.selectedGroup = group
    }

    /// Creates a group within a Team with the given teamId
    func createGroup(teamId: String?, groupTitle: String, memberIds: [String] = [], suppressBanner: Bool = false, isPublic: Bool = false) {

        if pFilter.containsProfanity(text: groupTitle).profanities.count > 0 {
            self.setBannerData(title: "Cannot create Group",
                               details: "Cannot use profanity in group title.",
                               type: .warning)
            self.showBanner = true
            return
        }

        // Get user id
        guard let uid = Auth.auth().currentUser?.uid else {
            // Set banner
            if !suppressBanner {
                self.setBannerData(title: "Cannot create Group",
                                   details: "Failed to find user ID. Make sure you are connected to the internet and try again.",
                                   type: .warning)
                self.showBanner = true
            }

            print("Failed to find user ID")
            return
        }

        // Check if uid is in admin list
        var ids = memberIds
        if !ids.contains(uid) {
            ids.append(uid)
        }

        // Populate new Group object
        var group = Group()
        group.groupTitle = groupTitle

        // Check to make sure group name is not empty
        guard !group.groupTitle.isEmpty else {
            // Set banner
            if !suppressBanner {
                self.setBannerData(title: "Cannot create Group",
                                   details: "Group name must not be empty.",
                                   type: .warning)
                self.showBanner = true
            }

            print("createGroup: Group name must not be empty")
            return
        }

        // Checks if teamid is nil
        guard let teamId = teamId else {
            // Set banner
            if !suppressBanner {
                self.setBannerData(title: "Cannot create Group",
                                   details: "No ID found for selected Team. Make sure you have a Team selected.",
                                   type: .warning)
                self.showBanner = true
            }

            print("createGroup: Team ID is nil, cannot create Group")
            return
        }

        // Check if team id matches selected team , create group
        let teamRef = db.collection("teams").document(teamId)
        teamRef.getDocument {(document, _) in
            if let document = document, document.exists {

            } else {
                // Set banner
                if !suppressBanner {
                    self.setBannerData(title: "Cannot create Group",
                                       details: "Selected Team ID not found in our database. Team may no longer exist. Wait a few seconds and try again.",
                                       type: .warning)
                    self.showBanner = true
                }

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
            "members": FieldValue.arrayUnion(ids),
            "sessions": FieldValue.arrayUnion([]),
            "dateCreated": Date(),
            "isPublic": isPublic
        ]) { err in
            if let err = err {
                // Set banner
                if !suppressBanner {
                    self.setBannerData(title: "Create Group failed",
                                       details: "Error: \(err.localizedDescription). Wait a few seconds and try again.",
                                       type: .error)
                    self.showBanner = true
                }

                print("createGroup: Error adding document: \(err)")
            } else {
                // Set banner
                if !suppressBanner {
                    self.setBannerData(title: "Success",
                                       details: "Group created successfully!",
                                       type: .success)
                    self.showBanner = true
                }

                self.wasCreateSuccess = true

                print("createGroup: Group document added successfully")
            }
        }
    }

    /// Updates current selected Group object according to database
    func getCurrentGroupInfo(teamId: String?) {

        guard let teamId = teamId else {
            print("getCurrentGroupInfo: TeamId is nil.")
            return
        }

        guard let groupId = selectedGroup?.groupId else {
            print("getCurrentGroupInfo: Selected GroupId is nil.")
            return
        }

        db.collection("teams").document(teamId).collection("groups").document(groupId).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                do {
                    // Convert document to Group object
                    try self.selectedGroup = querySnapshot?.data(as: Group.self)
                    print("getCurrentGroupInfo: Group object mapped successfully")
                } catch {
                    print("getCurrentGroupInfo: Error created Group object from db")
                }
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
                            self.groups = self.groups.sorted(by: {$0.dateCreated.compare($1.dateCreated) == .orderedDescending})
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

                    if self.selectedGroup == nil {
                        self.selectedGroup = self.groups.first
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

    func loadSelectedGroupMembers(includeCurrentUser: Bool = true) {
        self.groupMembers = []

        guard let selectedGroup = self.selectedGroup else {
            print("getSelectedGroupMembers: Selected Group is nil.")
            return
        }

        var members = selectedGroup.members

        // Strip current user from member list if necessary
        if !includeCurrentUser {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("loadSelectedGroupMembers: Cannot get user ID.")
                return
            }

            if let index = members.firstIndex(where: {$0 == uid}) { // find index of current user
                members.remove(at: index)
            }
        }

        let userCollectionRef = db.collection("users")
        var chunks: Int = members.count / 10
        let smallChunk = members.count % 10
        if smallChunk != 0 {
            chunks += 1
        }

        var chunk = 0
        var chunkMembers: [String] = []

        while chunk < chunks {
            if smallChunk != 0 && chunk == chunks - 1 {
                chunkMembers = Array(members[chunk*10...chunk*10+smallChunk-1])
            } else {
                chunkMembers = Array(members[chunk*10...chunk*10+9])
            }

            userCollectionRef.whereField("id", in: chunkMembers)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            do {
                                // Convert document to Member object and append to list of Group members
                                try self.groupMembers.append(document.data(as: Member.self)!)
                            } catch {
                                print("Error adding member to list of Group members")
                            }
                        }
                        self.groupMembers = self.groupMembers.sorted(by: {
                            $0.name.compare($1.name) == .orderedAscending
                        })
                    }
                }
            chunk += 1
        }
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

    func updateGroupTitle(newTitle: String, teamId: String?) {
        self.isLoading = true

        // Get current Group
        guard let currentGroup: Group = self.selectedGroup else {
            print("updateGroupTitle: Can't get selected Group")
            return
        }

        // Make sure TeamId is valid
        guard let teamId = teamId else {
            print("updateGroupTitle: TeamId is nil.")
            return
        }

        // Error validation
        if newTitle.isEmpty {
            self.isLoading = false

            // Set banner
            setBannerData(title: "Cannot change Group name",
                          details: "New name cannot be empty",
                          type: .warning)
            self.showBanner = true
        } else if newTitle == currentGroup.groupTitle {
            self.isLoading = false

            // Set banner
            self.setBannerData(title: "Cannot change Group name",
                               details: "New name cannot be the same as current name.",
                               type: .warning)
            self.showBanner = true
        } else if pFilter.containsProfanity(text: newTitle).profanities.count > 0 {
            self.isLoading = false

            // Set Banner
            setBannerData(title: "Cannot change Group name",
                          details: "New name cannot contain profanity.",
                          type: .warning)
            self.showBanner = true
        } else {
            // query db and update name in the document
            db.collection("teams").document(teamId).collection("groups").document(currentGroup.groupId).updateData([
                "groupTitle": newTitle
            ]) { err in
                if let err = err {
                    self.isLoading = false

                    // Set banner
                    self.setBannerData(title: "Cannot change Group name",
                                       details: "Error updating Group name. Please contact your admin. \(err)",
                                       type: .error)
                    self.showBanner = true

                    print("updateGroupTitle: Error updating Group title")
                } else {
                    self.isLoading = false
                    self.selectedGroup?.groupTitle = newTitle  // update view

                    // Set banner
                    self.setBannerData(title: "Success",
                                       details: "Group name updated successfully!",
                                       type: .success)
                    self.showBanner = true

                    print("updateGroupTitle: Group name updated successfully")
                }
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
