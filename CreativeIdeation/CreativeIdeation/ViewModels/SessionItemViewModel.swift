//
//  StickyItemViewModel.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-03.
//

import SwiftUI
import PencilKit
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFunctions
import Profanity_Filter

final class SessionItemViewModel: ObservableObject {

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    @Published var activeSession: Session?        // Session object of the currently active Session

    @Published var selectedItem: SessionItem?       // Currently selected SessionItem
    @Published var sessionItems: [SessionItem] = []    // List of StickyItems from the session that is currently active

    @Published var selectedSticky: StickyNote?      // Currently selected StickyNote
    @Published var stickyNotes: [StickyNote] = []       // Array of StickyNotes in the session

    @Published var votingStickies: [VotingSticky] = []  // Stickies to be voted on
    @Published var votedOnStack: [(VotingSticky, Int)] = []   // Stickies that have been voted on in current session

    @Published var generatedIdeas: [String] = []

    // Published vars for displaying like/dislike/skip/undo button animations
    @Published var showingLike = false
    @Published var showingSkip = false
    @Published var showingDislike = false
    @Published var isSpinning = false
    private var spinTimer: Timer?
    private var animationTimer: Timer?
    private var pFilter: ProfanityFilter = ProfanityFilter()

    enum SortingType {
        case alphabetical
        case score
        case color
    }

    let colorArray = [Color.init(red: 0.9, green: 0, blue: 0),
                      Color.init(red: 0.9, green: 0.5, blue: 0),
                      Color.init(red: 0, green: 0.9, blue: 0),
                      Color.init(red: 0, green: 0.7, blue: 0.9),
                      Color.init(red: 0.9, green: 0.45, blue: 0.9)]

    func resetModel() {
        clearAnimations()
        listener?.remove()
        spinTimer?.invalidate()
        animationTimer?.invalidate()
        votingStickies = []
        votedOnStack = []
        activeSession = nil
        selectedItem = nil
        sessionItems = []
        selectedSticky = nil
        stickyNotes = []
    }

    func updateLocation(location: CGPoint, itemId: String) {
        let locx = Int(location.x)
        let locy = Int(location.y)
        sessionItems[sessionItems.firstIndex(where: {$0.itemId == itemId})!].location = [locx, locy]
    }

    func updateText(text: String, itemId: String) {
        sessionItems[sessionItems.firstIndex(where: {$0.itemId == itemId})!].input = pFilter.maskProfanity(text: text)
    }

    func updateItem(itemId: String) {
        let itemReference = db.collection("session_items").document(itemId)
        let localItem = sessionItems.first(where: {$0.itemId == itemId})

        // swiftlint:disable multiple_closures_with_trailing_closure
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            // let itemDocument: DocumentSnapshot
            do {
                _ = try transaction.getDocument(itemReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            let newColor = localItem!.color
            let newLocation = localItem!.location
            let newInput = localItem!.input

            transaction.updateData(["color": newColor,
                                    "input": newInput,
                                    "location": newLocation],
                                   forDocument: itemReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating item: \(error)")
            }
        }
        // swiftlint:enable multiple_closures_with_trailing_closure
    }

    func castVote(itemId: String, scoreChange: Int) {
        // function for casting a vote and updating the database with the user id and the new score

        guard let uid = Auth.auth().currentUser?.uid else {
            print("populateVotingSheetin: Failed to get uid")
            return
        }

        if scoreChange == 1 {
            clearAnimations()
            self.showingLike.toggle()
            setAnimationTimer()
        } else {
            clearAnimations()
            self.showingDislike.toggle()
            setAnimationTimer()
        }

        let itemReference = db.collection("session_items").document(itemId)

        // swiftlint:disable multiple_closures_with_trailing_closure
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(itemReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            transaction.updateData(["score": FieldValue.increment(Int64(scoreChange)),
                                    "haveVoted": FieldValue.arrayUnion([uid])],
                                   forDocument: itemReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating item: \(error)")
            }
        }
    }

    func undoVote() {
        if votedOnStack.count > 0 {

            guard let uid = Auth.auth().currentUser?.uid else {
                print("populateVotingSheetin: Failed to get uid")
                return
            }

            let poppedSticky = votedOnStack.last!.0
            let scoreChange = -votedOnStack.last!.1
            print("Score in undoVote: ", scoreChange)

            votingStickies.append(poppedSticky)
            votedOnStack.remove(at: votedOnStack.count - 1)

            let itemReference = db.collection("session_items").document(poppedSticky.itemId)

            // swiftlint:disable multiple_closures_with_trailing_closure
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                do {
                    _ = try transaction.getDocument(itemReference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                transaction.updateData(["score": FieldValue.increment(Int64(scoreChange)),
                                        "haveVoted": FieldValue.arrayRemove([uid])],
                                       forDocument: itemReference)
                return nil
            }) { (_, error) in
                if let error = error {
                    print("Error updating item: \(error)")
                }
            }
        }
    }

    @objc func clearAnimations() {
        self.showingLike = false
        self.showingSkip = false
        self.showingDislike = false
    }

    @objc func animateSpinning() {
        self.isSpinning.toggle()
    }

    func setAnimationTimer() {
        // function for settings timers for like/dislike/skip animations
        animationTimer?.invalidate()
        animationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.clearAnimations), userInfo: nil, repeats: false)
    }

    /// Populate a list of stickies to be voted on in the voting stage of the Sticky Notes activity
    func populateVotingList() {

        votingStickies = []  // clear current list
        var votedOn: [String] = []  // list of stickies that have already been voted on by user
        spinTimer?.invalidate()
        spinTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.animateSpinning), userInfo: nil, repeats: true) // Timer for spin animations on upvote and downvote

        guard let uid = Auth.auth().currentUser?.uid else {
            print("populateVotingSheetin: Failed to get uid")
            return
        }

        // identify stickies that user already voted on
        for item in self.sessionItems {
            if item.haveVoted.contains(uid) {
                votedOn.append(item.itemId)
            }
        }

        // populate list of stickies yet to be voted on
        var pos = 0  // position of sticky in the list
        for sticky in self.stickyNotes {
            if !votedOn.contains(sticky.itemId) {
                self.votingStickies.append(VotingSticky(itemId: sticky.itemId, chosenColor: sticky.chosenColor!, input: sticky.input, pos: pos,
                                             onRemove: { removedStickyId in
                                                self.votedOnStack.append((self.votingStickies.first(where: { sticky in
                                                    sticky.itemId == removedStickyId
                                                })!, 0))
                                                self.votingStickies.removeAll {
                                                    $0.itemId == removedStickyId
                                                }
                                             }))
                pos += 1
            }
        }
    }

    func loadItems() {
        // Ensure Team ID is not nil
        guard let activeSession = activeSession else {
            print("Cannot get items: activeSession is nil")
            return
        }

        listener = db.collection("session_items").whereField("sessionId", in: [activeSession.sessionId])
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        // Add new item locally
                        do {
                            let newItem = try (diff.document.data(as: SessionItem.self)!)
                            self.sessionItems.append(newItem)
                            self.createSticky(newItem: newItem)
                        } catch {
                            print("Error reading new item from DB: \(error)")
                        }
                    }
                    if diff.type == .modified {
                        // Modify local item
                        do {
                            let mockItem = try (diff.document.data(as: SessionItem.self)!)
                            let docID = diff.document.documentID
                            let selectedItemIndex = self.sessionItems.firstIndex(where: {$0.itemId == docID})
                            let selectedStickyIndex = self.stickyNotes.firstIndex(where: {$0.itemId == docID})

                            self.sessionItems[selectedItemIndex!].color = mockItem.color
                            self.sessionItems[selectedItemIndex!].location = mockItem.location
                            self.sessionItems[selectedItemIndex!].input = mockItem.input
                            self.sessionItems[selectedItemIndex!].score = mockItem.score
                            self.sessionItems[selectedItemIndex!].haveVoted = mockItem.haveVoted

                            self.stickyNotes.remove(at: selectedStickyIndex!)
                            self.createSticky(newItem: self.sessionItems[selectedItemIndex!],
                                              selected: self.selectedSticky?.itemId == docID,
                                              index: selectedStickyIndex!)

                        } catch {
                            print("Error reading modified item from DB: \(error)")
                        }
                    }
                    if diff.type == .removed {
                        // Remove item locally
                        let selectedItemId = diff.document.documentID
                        let selectedItemIndex = self.sessionItems.firstIndex(where: {$0.itemId == selectedItemId})
                        let selectedStickyIndex = self.stickyNotes.firstIndex(where: {$0.itemId == selectedItemId})

                        if self.selectedSticky?.itemId == selectedItemId {
                            self.selectedSticky = nil
                            self.selectedItem = nil
                        }

                        self.sessionItems.remove(at: selectedItemIndex!)
                        self.stickyNotes.remove(at: selectedStickyIndex!)

                    }
                }
            }
    }

    func createItem(color: Int) {
        // Create a new sticky note and session item
        var newItem = SessionItem()
        newItem.color = color
        newItem.sessionId = activeSession!.sessionId

        let itemRef = db.collection("session_items").document()
        let batch = db.batch()
        batch.setData([
            "itemId": itemRef.documentID,
            "sessionId": newItem.sessionId,
            "input": newItem.input,
            "location": newItem.location,
            "color": newItem.color,
            "score": newItem.score,
            "haveVoted": newItem.haveVoted
        ], forDocument: itemRef)

        batch.commit { err in
            if let err = err {
                print("Error writing batch for createSticky: \(err)")
            } else {
                print("Item created successfully with id: \(itemRef.documentID)")
            }
        }
    }

    func createSticky(newItem: SessionItem, selected: Bool = false, index: Int = -1) {
        let newSticky = StickyNote(
            input: newItem.input,
            location: CGPoint(x: newItem.location[0], y: newItem.location[1]),
            itemId: newItem.itemId,
            numberColor: newItem.color,
            chosenColor: self.colorArray[newItem.color],
            selected: selected,
            score: newItem.score
        )
        if index < 0 {
            stickyNotes.append(newSticky)
        } else {
            stickyNotes.insert(newSticky, at: index)
        }
    }

    func updateSelected(note: StickyNote) {
        clearSelected()
        selectedSticky = note
        selectedItem = sessionItems.first(where: {$0.itemId == note.itemId})
    }

    func clearSelected() {
        selectedSticky?.selected = false
        selectedSticky = nil
        selectedItem = nil
    }

    func deleteSelected() {
        // Delete the selected sticky
        let selectedItemId = selectedSticky!.itemId

        db.collection("session_items").document(selectedItemId).delete { err in
            if let err = err {
                print("Error deleting session item: \(err)")
            } else {
                print("Session item deleted!")
            }
        }

        clearSelected()
    }

    func colorSelected(color: Int) {
        // Change the colour of the selected sticky
        sessionItems[sessionItems.firstIndex(where: {$0.itemId == selectedSticky!.itemId})!].color = color
        selectedSticky?.chosenColor = self.colorArray[color]
        self.updateText(text: selectedSticky!.input, itemId: selectedSticky!.itemId)
    }

    func generateIdeas() {
        // Get random sticky note's text
        guard var input = sessionItems.randomElement()?.input else {
            print("generateIdeas: SessionItem not found or input empty - returning empty array")
            return
        }
        // Trim the text
        input = input.trimmingCharacters(in: .whitespacesAndNewlines)
        // Get all words in input
        let words = input.components(separatedBy: " ")
        // Get random word from input and remove any non alpha characters and lowercase it
        let query = words.randomElement()!
            .lowercased()
            .filter("abcdefghijklmnopqrstuvwxyz".contains)

        print(query)

        // Call API that returns an array of Strings
        let functions = Functions.functions()
        functions.httpsCallable("generate_ideas").call(["word": query]) { (result, error) in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    // Errors thrown by server
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    print("Error \(code!): \(message)")
                }
                // Handle other errors
                print("Cloud function didn't work")
            } else {
                // On Completion
                print("Generate Ideas CF ran successfully.")
                if let response = result?.data as? NSDictionary {
                    if let words: [String] = response["result"] as? [String] {
                        self.generatedIdeas = words
                    }
                }
            }
        }
    }

    func sortStickies(sortBy: SortingType) {
        switch sortBy {
        case .alphabetical:
            stickyNotes.sort { $0.input < $1.input }
        case .score:
            stickyNotes.sort { $0.score > $1.score }
        case .color:
            stickyNotes.sort { $0.numberColor < $1.numberColor}
        }
    }

    func clearIdeas() {
        self.generatedIdeas = []
    }
}
