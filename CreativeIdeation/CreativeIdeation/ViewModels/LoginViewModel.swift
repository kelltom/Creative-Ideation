//
//  LoginViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-17.
//

import Foundation
import Firebase

final class LoginViewModel: ObservableObject {
    
    //private var dbService : DBService!
    private var db = Firestore.firestore()
    
    @Published var user = User()
    @Published var authSuccess = false
    @Published var msg = ""
    @Published var showBanner = false
    
    func authenticate() {
        // async
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.msg = error?.localizedDescription ?? ""
                self.authSuccess = false
                self.showBanner = true // signal UI to display a banner
            } else {
                print("Success")
                self.msg = "Success"
                self.authSuccess = true
                self.showBanner = true // signal UI to display a banner
            }
        }
    }
    
}
