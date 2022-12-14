//
//  SessionViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Profanity_Filter

struct ProfanityUser: Hashable {
    var id = ""
    var name = ""
    var email = ""
    var profanityList: [String] = []
}

final class SessionViewModel: ObservableObject {

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    private var pFilter = ProfanityFilter()

    @Published var selectedGroupId: String?
    @Published var groupSessions: [Session] = []    /// List of Sessions from a group that the user belongs to
    @Published var teamSessions: [Session] = []     /// List of Sessions from a team that the user belongs to
    @Published var selectedSession: Session?        /// Session object of the selected Session
    @Published var newSession = Session()           /// Session object used when creating new Sessions, binds to UI
    @Published var timerManager = TimerManager()
    @Published var profUser: ProfanityUser?
    @Published var profanityUsers: [ProfanityUser] = []
    @Published var profanityCollection: [String] = []
    @Published var lengthOfTotalWordCount: Double = 0.0
    @Published var lengthOfProfanityWords: Double = 0.0

    @Published var msg = ""
    @Published var didOperationSucceed = false

    @Published var showBanner = false
    @Published var bannerData: BannerModifier.BannerData =
    BannerModifier.BannerData(title: "Default Title",
                              detail: "Default detail message.",
                              type: .info)

    /// clears the model
    func clear() {
        teamSessions = []
        groupSessions = []
        selectedSession = nil
        selectedGroupId = nil
        newSession = Session()
        timerManager = TimerManager()
        profUser = nil
        profanityUsers = []
        profanityCollection = []
        listener?.remove()
    }

    /// Function for updating DateModified of the selectedSession when a stickyNote is edited
    func updateDateModified() {
        guard let activeSession = selectedSession else {
            print("Could not upate DateModified: No active session")
            return
        }

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        // swiftlint:disable multiple_closures_with_trailing_closure
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(sessionReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            transaction.updateData(["dateModified": FieldValue.serverTimestamp()],
                                   forDocument: sessionReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating session: \(error)")
            }
        }
    }

    /// Creates a Session within a Group with the given groupId
    func createSession(teamId: String?, groupId: String?) {
        // This needs to be a batched write. We are writing to both the Group document,
        // and the Session document - adding either ID to either document as foreign keys.

        if pFilter.containsProfanity(text: newSession.sessionTitle).profanities.count > 0 || pFilter.containsProfanity(text: newSession.sessionDescription).profanities.count > 0 {
            self.setBannerData(title: "Cannot create Session",
                               details: "Cannot use profanity in session title or description.",
                               type: .warning)
            self.showBanner = true
            newSession.sessionTitle = ""
            newSession.sessionDescription = ""
            return
        }

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            // Set banner
            self.setBannerData(title: "Cannot create Session",
                               details: "Failed to find user ID. Make sure you are connected to the internet and try again.",
                               type: .warning)
            self.showBanner = true

            print("Failed to find user ID")
            return
        }

        // Check to make sure session name is not empty
        guard !newSession.sessionTitle.isEmpty else {
            // Set banner
            self.setBannerData(title: "Cannot create Session",
                               details: "Session name must not be empty.",
                               type: .warning)
            self.showBanner = true

            print("Session title cannot be empty")
            return
        }

        // Check if group is nil - session must belong to a group
        guard let groupId = groupId else {
            // Set banner
            self.setBannerData(title: "Cannot create Session",
                               details: "Cannot find selected Group. Make sure a Group is selected before creating a Session.",
                               type: .warning)
            self.showBanner = true

            print("groupID is nil - cannot create session")
            return
        }

        // Check if team is nil - group must belong to a team
        guard let teamId = teamId else {
            // Set banner
            self.setBannerData(title: "Cannot create Session",
                               details: "Cannot find selected Team. Make sure a Team is selected before creating a Session.",
                               type: .warning)
            self.showBanner = true

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
            "stage": 1,
            "dateCreated": Date(),
            "dateModified": Date(),
            "createdBy": uid,
            "timerEnd": Date().addingTimeInterval(600),
            "timerActive": false,
            "timeRemaining": 600,
            "groupId": groupId,
            "teamId": teamId,
            "castFinalVote": [],
            "finalVotes": [:],
            "profanityLog": [:]
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

                // Set banner
                self.setBannerData(title: "Failed to create Session",
                                   details: "Create Session failed. Make sure you're connected to the internet and try again.",
                                   type: .error)
                self.showBanner = true
            } else {
                print("Session created successfully with id: \(sessionRef.documentID)")

                // Set banner
                self.setBannerData(title: "Success",
                                   details: "Successfully created Session.",
                                   type: .success)
                self.showBanner = true

                self.didOperationSucceed = true
            }
        }
    }

    /// gets profanity data to be graphed in the profanity log
    func getGraphData() {
        var totalWord: [String] = []
        var totalProfanityWords: [String] = []
        // get the current session id
        guard let activeSession = selectedSession else {
            print("Could not get active session")
            return
        }

        // gets the number of total words used in a session
        db.collection("session_items").whereField("sessionId", isEqualTo: activeSession.sessionId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let input = document.data()["input"] as? String ?? "n/a"

                        if input.contains("*") {
                            totalProfanityWords.append(input)
                        } else {
                            totalWord.append(input)
                        }
                    }
                    self.lengthOfTotalWordCount = Double(totalWord.count)
                    self.lengthOfProfanityWords = Double(totalProfanityWords.count)

                }
            }

    }

    /// creates a listener to populate the sessions array, and adds/updates/removes sessions as changes occur in the DB
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
                            self.teamSessions = self.teamSessions.sorted(by: {$0.dateModified.compare($1.dateModified) == .orderedDescending})
                            if newSession.groupId == self.selectedGroupId {
                                self.groupSessions.append(newSession)
                                self.groupSessions = self.groupSessions.sorted(by: {$0.dateModified.compare($1.dateModified) == .orderedDescending})
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
                            self.teamSessions[selectedSessionIndex!].stage = mockSession.stage
                            self.teamSessions[selectedSessionIndex!].dateModified = mockSession.dateModified
                            self.teamSessions[selectedSessionIndex!].timerEnd = mockSession.timerEnd
                            self.teamSessions[selectedSessionIndex!].timerActive = mockSession.timerActive
                            self.teamSessions[selectedSessionIndex!].timeRemaining = mockSession.timeRemaining
                            self.teamSessions[selectedSessionIndex!].castFinalVote = mockSession.castFinalVote
                            self.teamSessions[selectedSessionIndex!].finalVotes = mockSession.finalVotes
                            self.teamSessions[selectedSessionIndex!].profanityLog = mockSession.profanityLog

                            if self.selectedSession != nil && mockSession.sessionId == self.selectedSession?.sessionId {
                                if mockSession.timerActive {
                                    self.getRemainingTime(endTime: mockSession.timerEnd)
                                    self.timerManager.start()
                                } else {
                                    self.timerManager.pause()
                                    self.timerManager.timeRemaining = mockSession.timeRemaining
                                }
                                self.selectedSession!.timerActive = mockSession.timerActive
                                self.selectedSession!.timerEnd = mockSession.timerEnd
                                self.selectedSession!.timeRemaining = mockSession.timeRemaining
                                self.selectedSession!.stage = mockSession.stage
                                self.selectedSession!.castFinalVote = mockSession.castFinalVote
                                self.selectedSession!.finalVotes = mockSession.finalVotes
                                self.selectedSession!.profanityLog = mockSession.profanityLog
                            }

                            let selectedSessionGroupIndex = self.groupSessions.firstIndex(where: {$0.sessionId == mockSession.sessionId})
                            if selectedSessionGroupIndex != nil {
                                self.groupSessions[selectedSessionGroupIndex!].sessionTitle = mockSession.sessionTitle
                                self.groupSessions[selectedSessionGroupIndex!].sessionDescription = mockSession.sessionDescription
                                self.groupSessions[selectedSessionGroupIndex!].inProgress = mockSession.inProgress
                                self.groupSessions[selectedSessionGroupIndex!].dateModified = mockSession.dateModified
                                self.groupSessions[selectedSessionGroupIndex!].stage = mockSession.stage
                                self.groupSessions[selectedSessionGroupIndex!].timerActive = mockSession.timerActive
                                self.groupSessions[selectedSessionGroupIndex!].timerEnd = mockSession.timerEnd
                                self.groupSessions[selectedSessionGroupIndex!].timeRemaining = mockSession.timeRemaining
                            }

                            self.teamSessions = self.teamSessions.sorted(by: {$0.dateModified.compare($1.dateModified) == .orderedDescending})
                            self.groupSessions = self.groupSessions.sorted(by: {$0.dateModified.compare($1.dateModified) == .orderedDescending})

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

    /// deletes a session from the DB
    func deleteSession(sessionId: String) {
        let batch = db.batch()

        // Delete Sessions
        db.collection("sessions").whereField("sessionId", isEqualTo: sessionId)
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

        // Delete Session from Settings Id
        db.collection("session_settings").whereField("sessionId", isEqualTo: sessionId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        batch.deleteDocument(document.reference)
                    }
                }
            }
        // Delete Session from seession_items Id
        db.collection("session_items").whereField("sessionId", isEqualTo: sessionId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        batch.deleteDocument(document.reference)
                    }
                }
            }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            batch.commit { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded.")
                    self.selectedSession = nil
                }
            }
        }

    }

    /// checks the input string for profanity, and adds to the profanity log in the DB if necessary
    func checkProfanity(textInput: String) {

        guard let uid = Auth.auth().currentUser?.uid else {
            print("cannot find uid for user who swore")
            return
        }
        guard let activeSession = selectedSession else {
            print("Could not get active session")
            return
        }
        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        if pFilter.containsProfanity(text: textInput).profanities.count > 0 {
            self.profanityCollection.append(textInput)
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    _ = try transaction.getDocument(sessionReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                // sorts word by frequency
                self.profanityCollection = self.profanityCollection.sorted { first, second in
                    self.profanityCollection.filter { $0 == first }.count > self.profanityCollection.filter { $0 == second }.count
                }

                transaction.updateData(["profanityLog.\(uid)": self.profanityCollection],
                                       forDocument: sessionReference)
                return nil

            }) { (_, error) in
                if let error = error {
                    print("Error updating session: \(error)")
                }
            }
        }
    }

    /// retrieves the profanity log for the current session
    func getProfanityList(sessionMembers: [String]) {

        var profanityDict: [String: [String]] = [:]
        var profanityUsersTemp: [ProfanityUser] = []
        self.profanityUsers = []

        guard let activeSession = selectedSession else {
            print("Could not get active session")
            return
        }

        db.collection("sessions").document(activeSession.sessionId)
            .getDocument {(querySnapshot, err) in
                if let err = err {
                    print("error in getting documents: \(err)")
                } else {
                    do {
                        try self.selectedSession = querySnapshot?.data(as: Session.self)
                        profanityDict = self.selectedSession?.profanityLog ?? ["n/a": ["n/a"]]
                        // check if users have sworn in this session
                        if profanityDict.isEmpty {
                            self.profanityUsers = []
                            return
                        }
                        self.db.collection("users").whereField("id", in: profanityDict.keys.sorted()).getDocuments { (snapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for documentSnap in snapshot!.documents {
                                    do {
                                        var tempUser: User
                                        try tempUser = documentSnap.data(as: User.self)!
                                        let profanityUserTemp: ProfanityUser = ProfanityUser(id: tempUser.id,
                                                                                             name: tempUser.name,
                                                                                             email: tempUser.email,
                                                                                             profanityList: profanityDict[tempUser.id] ?? ["unknown"])
                                        profanityUsersTemp.append(profanityUserTemp)
                                    } catch {
                                        print("Error adding member to list of Group members")
                                    }
                                }
                                profanityUsersTemp = profanityUsersTemp.sorted(by: {$0.profanityList.count > $1.profanityList.count})
                                self.profanityUsers = profanityUsersTemp

                            }
                        }
                    } catch {
                        print("Session could not be properly mapped to object")
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
        groupSessions = groupSessions.sorted(by: {$0.dateModified.compare($1.dateModified) == .orderedDescending})
    }

    /// toggles the timer on/off
    func toggleTimer(timeRemaining: Double) {

        selectedSession?.timerActive.toggle()

        guard let activeSession = selectedSession else {
            print("Could not upate timerActive: No active session")
            return
        }

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        if activeSession.timerActive {
            let endTime = Date().addingTimeInterval(timeRemaining)

            // swiftlint:disable multiple_closures_with_trailing_closure
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    _ = try transaction.getDocument(sessionReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                transaction.updateData(["timerActive": activeSession.timerActive,
                                        "timerEnd": endTime],
                                       forDocument: sessionReference)
                return nil
            }) { (_, error) in
                if let error = error {
                    print("Error updating session: \(error)")
                }
            }

        } else {
            // swiftlint:disable multiple_closures_with_trailing_closure

            db.runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    _ = try transaction.getDocument(sessionReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                print("Writing Time Remaining: ", self.timerManager.timeRemaining)
                transaction.updateData(["timerActive": activeSession.timerActive,
                                        "timeRemaining": self.timerManager.timeRemaining],
                                       forDocument: sessionReference)
                return nil
            }) { (_, error) in
                if let error = error {
                    print("Error updating session: \(error)")
                }
            }
        }
    }

    /// gets the remaining time for the timer
    func getRemainingTime(endTime: Date) {
        let remainingTime = max(endTime.timeIntervalSince(Date()), 0)
        timerManager.timeRemaining = Int(remainingTime)
    }

    /// reset the timer in the DB
    func resetTimer(time: Int) {
        let newTime = time

        guard let activeSession = selectedSession else {
            print("Could not reset timeRemaining: No active session")
            return
        }

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(sessionReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            print("Resetting Timer. Time Remaining: ", newTime)
            transaction.updateData(["timeRemaining": newTime],
                                   forDocument: sessionReference)

            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating session: \(error)")
            }
        }
    }

    /// changes the stage to the second round of voting (3)
    func finishVoting() {
        guard let activeSession = selectedSession else {
            print("Could not finish voting: No active session")
            return
        }

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(sessionReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            print("Finishing Voting")
            transaction.updateData(["stage": 3],
                                   forDocument: sessionReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating session: \(error)")
            }
        }
    }

    /// Changes the stage to the voting stage (2)
    func beginVoting() {
        guard let activeSession = selectedSession else {
            print("Could not begin voting: No active session")
            return
        }

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(sessionReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            print("Finishing Voting")
            transaction.updateData(["stage": 2],
                                   forDocument: sessionReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating session: \(error)")
            }
        }
    }

    /// changes the stage to the best idea stage (4)
    func finishTopVoting() {
        guard let activeSession = selectedSession else {
            print("Could not finish voting: No active session")
            return
        }

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(sessionReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            print("Finishing Voting")
            transaction.updateData(["stage": 4],
                                   forDocument: sessionReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating session: \(error)")
            }
        }
    }

    /// casts the final vote from the user for round 2 of voting
    func castFinalVote(itemId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("cannot find uid for current user")
            return
        }

        guard let activeSession = selectedSession else {
            print("Could not get active session")
            return
        }
        selectedSession!.castFinalVote.append(uid)

        let sessionReference = db.collection("sessions").document(activeSession.sessionId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(sessionReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            transaction.updateData(["finalVotes.\(itemId)": FieldValue.increment(Int64(1)),
                                    "castFinalVote": FieldValue.arrayUnion([uid])],
                                   forDocument: sessionReference)
            return nil

        }) { (_, error) in
            if let error = error {
                print("Error casting final vote: \(error)")
            }
        }
    }

    /// checks whether the user has cast their final vote
    func didCastFinalVote() -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("cannot find uid for current user")
            return false
        }

        return selectedSession?.castFinalVote.contains(uid) ?? false
    }

    /// returns an array of the ID(s) of the best idea(s)
    func getBestIds() -> [String] {
        let highestVote = selectedSession!.finalVotes.values.max()
        return selectedSession!.finalVotes.filter { $1 == highestVote }.map { $0.0 }
    }

    /// Assigns values to the published BannerData object
    private func setBannerData(title: String, details: String, type: BannerModifier.BannerType) {
        bannerData.title = title
        bannerData.detail = details
        bannerData.type = type
    }
}
