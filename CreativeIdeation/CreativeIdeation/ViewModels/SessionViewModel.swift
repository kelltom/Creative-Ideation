//
//  SessionViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class SessionViewModel: ObservableObject {
    
    private var db = Firestore.firestore()
    
    @Published var groupSessions: [Session] = []    /// List of Sessions from a group that the user belongs to
    @Published var teamSessions: [Session] = []     /// List of Sessions from a team that the user belongs to, sorted by dateModified
    @Published var selectedSession: Session?        /// Session object of the selected Session
    @Published var newSession = Session()           /// Session object used when creating new Sessions, binds to UI

    /// Creates a Session within a Group with the given groupId
    func createSession(groupId: String?) {
        // This needs to be a batched write. We are writing to both the Group document, and the Session document - adding either ID to either document as foreign keys.
    }
    
    /// Populates teamSessions array, storing a Session object for each found in the datastore
    func getAllSessions(teamId: String?) {
    
    }
    
    /// Populates groupSessions array, storing a Session object for each found in the datastore
    func getGroupSessions(groupId: String?) {
        
    }
    
}
