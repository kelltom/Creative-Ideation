//
//  CreativeIdeationApp.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-02-14.
//

import SwiftUI
import Firebase

@main
struct CreativeIdeationApp: App {
    var userAccountViewModel: UserAccountViewModel
    var teamViewModel: TeamViewModel
    var groupViewModel: GroupViewModel
    var sessionViewModel: SessionViewModel
    var sessionItemViewModel: SessionItemViewModel

    init() {
        FirebaseApp.configure()
        userAccountViewModel = UserAccountViewModel()  // needs to instantiate after Firebase configures
        teamViewModel = TeamViewModel()
        groupViewModel = GroupViewModel()
        sessionViewModel = SessionViewModel()
        sessionItemViewModel = SessionItemViewModel()
    }
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(userAccountViewModel)
                .environmentObject(teamViewModel)
                .environmentObject(groupViewModel)
                .environmentObject(sessionViewModel)
        }
    }
}
