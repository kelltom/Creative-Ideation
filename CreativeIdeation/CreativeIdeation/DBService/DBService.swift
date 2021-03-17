//
//  DBService.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-17.
//

import Foundation
import Firebase

class DBService {
    
    private let db = Firestore.firestore()
    
    func authenticate(email: String, password: String) -> (Bool, String) {
        var success = false
        var msg = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                msg = error?.localizedDescription ?? ""
                success = false
            } else {
                print("Success")
                msg = "Success"
                success = true
            }
        }
        return (success, msg)
    }
}
