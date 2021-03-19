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
        
    init() {
        FirebaseApp.configure()
        userAccountViewModel = UserAccountViewModel() // needs to instantiate after Firebase configures, since it uses Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(userAccountViewModel)
        }
    }
}
