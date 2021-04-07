//
//  UserAccountViewModel.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-18.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseFirestoreSwift

final class UserAccountViewModel: ObservableObject {

    // private var dbService : DBService! 
    private var db = Firestore.firestore()

    @Published var authSuccess = false
    @Published var createSuccess = false
    @Published var msg = ""
    @Published var showBanner = false
    @Published var selectedUser: User?

    func authenticate(email: String, password: String) {
        self.showBanner = false

        // Populate User object
        var user = User()
        user.email = email
        user.password = password

        // Authenticate user credentials
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (_, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.msg = error?.localizedDescription ?? ""
                self.authSuccess = false
            } else {
                print("Success")
                self.msg = "Success"
                self.authSuccess = true
            }

            // Display result to View
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
        }
    }

    func loggedInUser() { // reading the database onAppear in UpdateEmailSettings
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        print(uid)
        db.collection("users").document(uid)
            .getDocument { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    do {
                        // Convert document to User object
                        try self.selectedUser = querySnapshot?.data(as: User.self)
                        print("User object mapped successfully")
                    } catch {
                        print("Error createing object to USER")
                    }
                }
            }
    }

    // updating db
    func updateUserInfo(email: String) {

        var user = User()
        user.email = email

        //getting user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        //get current user
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        // updates email authentication
        currentUser.updateEmail(to: email) { error in
            if error != nil {
                print(error?.localizedDescription ?? "email update did not work")
            } else {
                print("Email update succesfull")
                //updates email address in document collection
                self.db.collection("users").document(uid).updateData([
                    "email": user.email
                ]) { err in
                    if let err = err {
                        print("Error updating user email: \(err)")
                    } else {
                        print("user email updated successfully")
                    }
                }
            }

        }

    }

    func createAccount(name: String, email: String, password: String) {
        self.showBanner = false

        // Populate User object
        var user = User()
        user.name = name
        user.email = email
        user.password = password

        // Add new User to authenticated list
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error creating account")
                self.msg = error?.localizedDescription ?? "Error creating account"
                self.createSuccess = false

                // Display results to View
                withAnimation {
                    self.showBanner = true
                    self.delayAlert()
                }

            } else {
                print("Successfully created User auth")

                // Mirror user in DB (ideally, it would take the User object and convert to document
                self.db.collection("users").document((authResult?.user.uid)! as String).setData([
                    "name": user.name,
                    "email": user.email,
                    "id": authResult?.user.uid as Any
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                        self.msg = "Error adding document: \(err)"
                        self.createSuccess = false
                    } else {
                        print("Document added with")
                        self.msg = "Account created successfully!"
                        self.createSuccess = true
                    }

                    // Display results to View
                    withAnimation {
                        self.showBanner = true
                        self.delayAlert()
                    }
                }
            }

        }
    }


    // Tells View to stop showing banner after 4 seconds
    private func delayAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation {
                self.showBanner = false
            }
        }
    }

}
