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
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
