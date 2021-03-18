//
//  CreateAccountViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-17.
//

import Foundation
import Firebase

final class CreateAccountViewModel: ObservableObject {
    
    //private var dbService : DBService!
    private var db = Firestore.firestore()
    
    @Published var user = User()
    @Published var createSuccess = false
    @Published var msg = ""
    @Published var showBanner = false
    
    func createAccount() {
        // Add new User to authenticated list
        Auth.auth().createUser(withEmail: user.email, password: user.password)
        { authResult, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error creating account")
                self.msg = error?.localizedDescription ?? "Error creating account"
                self.createSuccess = false
                self.showBanner = true
            } else {
                print("Successfully created User auth")
                
                // Mirror user in DB
                var ref: DocumentReference? = nil
                ref = self.db.collection("users").addDocument(data: [
                    "name": self.user.name,
                    "email": self.user.email,
                    "id": authResult?.user.uid as Any
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        self.msg = "Error adding document: \(err)"
                        self.createSuccess = false
                        self.showBanner = true
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        self.msg = "Account created successfully!"
                        self.createSuccess = true
                        self.showBanner = true
                    }
                }
            }
            
        }
    }
    
}
