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

final class SessionItemViewModel: ObservableObject {

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    @Published var activeSession: Session?        // Session object of the currently active Session

    @Published var selectedItem: SessionItem?       // Currently selected SessionItem
    @Published var sessionItems: [SessionItem] = []    // List of StickyItems from the session that is currently active

    @Published var selectedSticky: StickyNote?      // Currently selected StickyNote
    @Published var stickyNotes: [StickyNote] = []       // Array of StickyNotes in the session

    let colorArray = [Color.init(red: 0.9, green: 0, blue: 0),
                      Color.init(red: 0, green: 0.9, blue: 0),
                      Color.init(red: 0, green: 0.7, blue: 0.9),
                      Color.init(red: 0.9, green: 0.9, blue: 0),
                      Color.init(red: 0.9, green: 0.45, blue: 0.9)]

    func resetModel() {
        listener?.remove()
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
        sessionItems[sessionItems.firstIndex(where: {$0.itemId == itemId})!].input = text
    }

    func updateItem(itemId: String) {
        let itemReference = db.collection("session_items").document(itemId)
        let localItem = sessionItems.first(where: {$0.itemId == itemId})

        // swiftlint:disable multiple_closures_with_trailing_closure
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let itemDocument: DocumentSnapshot
            do {
                try itemDocument = transaction.getDocument(itemReference)
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
            } else {
                print("Item Updated")
            }
        }
        // swiftlint:enable multiple_closures_with_trailing_closure
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

                            self.stickyNotes.remove(at: selectedStickyIndex!)
                            self.createSticky(newItem: self.sessionItems[selectedItemIndex!],
                                              selected: self.selectedSticky?.itemId == docID)

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
            "color": newItem.color
        ], forDocument: itemRef)

        batch.commit { err in
            if let err = err {
                print("Error writing batch for createSticky: \(err)")
            } else {
                print("Item created successfully with id: \(itemRef.documentID)")
            }
        }
    }

    func createSticky(newItem: SessionItem, selected: Bool = false) {
        let newSticky = StickyNote(
            input: newItem.input,
            location: CGPoint(x: newItem.location[0], y: newItem.location[1]),
            itemId: newItem.itemId,
            chosenColor: self.colorArray[newItem.color],
            selected: selected
        )
        stickyNotes.append(newSticky)
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
    }

    func generateIdeas() -> [String] {
        // Get random sticky note's text
        guard var input = sessionItems.randomElement()?.input else {
            print("generateIdeas: SessionItem not found or input empty - returning empty array")
            return []
        }
        // Trim the text
        input = input.trimmingCharacters(in: .whitespacesAndNewlines)
        // Get all words in input
        let words = input.components(separatedBy: " ")
        // Get random word from input and remove any non alpha characters and lowercase it
        let query = words.randomElement()!
            .filter("abcdefghijklmnopqrstuvwxyz".contains)
            .lowercased()

        // Call API that returns an array of Strings
        var url: String = "https://us-central1-creative-ideation.cloudfunctions.net/hello_http?word=" + query


        return []
    }
}
