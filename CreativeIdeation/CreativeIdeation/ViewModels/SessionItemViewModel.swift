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

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let itemDocument: DocumentSnapshot
            do {
                try itemDocument = transaction.getDocument(itemReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard let _ = itemDocument.data()?["input"] as? String else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve input from snapshot \(itemDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            guard let _ = itemDocument.data()?["color"] as? Int else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve color from snapshot \(itemDocument)"
                    ]
                )
                errorPointer?.pointee = error
                return nil
            }

            guard let _ = itemDocument.data()?["location"] as? [Int] else {
                let error = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve location from snapshot \(itemDocument)"
                    ]
                )
                errorPointer?.pointee = error
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
        }) {(_, error) in
            if let error = error {
                print("Error updating item: \(error)")
            } else {
                print("Item Updated")
            }
        }
    }

    func loadItems() {
        // Ensure Team ID is not nil
        guard let activeSession = activeSession else {
            print("Cannot get items: activeSession is nil")
            return
        }

        db.collection("session_items").whereField("sessionId", in: [activeSession.sessionId])
            .addSnapshotListener { (snapshot, error) in
                switch (snapshot, error) {
                case(.none, .none):
                    print("No new data")
                case(.none, .some(let error)):
                    print("Error: \(error.localizedDescription)")
                case(.some(let snapshot), _):
                    self.sessionItems = []
                    self.stickyNotes = []
                    print("Arrays Cleared")
                    for document in snapshot.documents {
                        do {
                            // Convert document to SessionItem object and append to list of sessionItems
                            let item = try (document.data(as: SessionItem.self)!)
                            self.sessionItems.append(item)
                            print("SessionItem object added to list of sessionItems")
                            self.createSticky(newItem: item)
                        } catch {
                            print("Error adding SessionItem object to list of sessionItems")
                        }
                    }
                }
            }

        // Get list of Sessions that belong to Team ID
//        db.collection("session_items").whereField("sessionId", in: [activeSession.sessionId])
//            .getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("Error getting session items: \(error)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        do {
//                            // Convert document to SessionItem object and append to list of sessionItems
//                            let item = try (document.data(as: SessionItem.self)!)
//                            self.sessionItems.append(item)
//                            print("SessionItem object added to list of sessionItems")
//                            self.createSticky(newItem: item)
//                        } catch {
//                            print("Error adding SessionItem object to list of sessionItems")
//                        }
//                    }
//                }
//            }
    }

    func createItem(color: Int) {
        // Create a new sticky note and session item
        var newItem = SessionItem()
        newItem.color = color
        newItem.sessionId = activeSession!.sessionId
        sessionItems.append(newItem)

        createSticky(newItem: newItem)

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

    func createSticky(newItem: SessionItem) {
        let newSticky = StickyNote(
            input: newItem.input,
            location: CGPoint(x: newItem.location[0], y: newItem.location[1]),
            itemId: newItem.itemId,
            chosenColor: self.colorArray[newItem.color],
            selected: false
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
        let selectedItemIndex = sessionItems.firstIndex(where: {$0.itemId == selectedSticky!.itemId})
        let selectedStickyIndex = stickyNotes.firstIndex(where: {$0.id == selectedSticky!.id})
        let selectedItemId = selectedSticky!.itemId

        sessionItems.remove(at: selectedItemIndex!)
        stickyNotes.remove(at: selectedStickyIndex!)

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
}
