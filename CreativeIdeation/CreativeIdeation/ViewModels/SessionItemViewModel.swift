//
//  StickyItemViewModel.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-03.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class SessionItemViewModel: ObservableObject {

    private var db = Firestore.firestore()

    @Published var activeSession: Session?        // Session object of the currently active Session
    @Published var sessionItems: [SessionItem] = []    // List of StickyItems from the session that is currently active

    @Published var selectedSticky: StickyNote?      // Currently selected StickyNote
    @Published var stickyNotes: [StickyNote] = []       // Array of StickyNotes in the session

    func createSticky() {
        // Create a new sticky note and session item
    }

    func deleteSelected() {
        // Delete the selected sticky
    }
    func colorSelected() {
        // Change the colour of the selected sticky
    }
}
