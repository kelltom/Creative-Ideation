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
    @Published var logOutSuccess = false
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

    /// Sign out
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.authSuccess = false
            print("signed out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    /// Populates selectedUser attribute
    func getCurrentUserInfo() { // reading the database onAppear in UpdateEmailSettings
        self.showBanner = false
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        // getting logged in user information
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
                        print("Error creating object to User")
                    }
                }
            }
    }

    /// Updates user's email with input
    func updateUserEmail(email: String) {
        self.showBanner = false

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Could not find signed-in user's ID")
            return
        }

        // Get current user
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        var user = User()
        user.email = email
        let oldEmail = currentUser.email!

        // Error checking before updating to DB
        if email.isEmpty {
            self.msg = "Email cannot be empty"
            self.createSuccess = false  // this should probably be changed to "updateSuccess"
            // Display results to View
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
            print("Update failed: Email cannot be empty")

        } else if oldEmail.lowercased() == user.email.lowercased() {  // needs to query the entire user collection still
            self.msg = "Email cannot be same as previous email"
            self.createSuccess = false
            // Display results to View
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
            print("Update failed: Email cannot be same as old email")

        } else {
            // Update email
            currentUser.updateEmail(to: email) { error in
                if error != nil {
                    print(error?.localizedDescription ?? "Email update failed")
                    self.msg = error?.localizedDescription ?? "Error updating email"
                    self.createSuccess = false
                } else {
                    // Updates email address in corresponding document collection
                    self.db.collection("users").document(uid).updateData([
                        "email": user.email
                    ]) { err in
                        if let err = err {
                            print("Error updating user email: \(err)")
                            self.msg = "Error updating user email  \(err)"
                            self.createSuccess = false
                            // Display result to View
                            withAnimation {
                                self.showBanner = true
                                self.delayAlert()
                            }
                        } else {
                            print("User email updated successfully")
                            self.msg = "Email updated successfully!"
                            self.createSuccess = true
                            self.selectedUser?.email = user.email
                            // Display result to View
                            withAnimation {
                                self.showBanner = true
                                self.delayAlert()
                            }
                        }
                    }
                }
            }
        }
    }

    func updateUserPassword(newPassword: String, confirmPassword: String, oldPassword: String) {
        self.showBanner = false

        // Get current user
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let currentUsersEmail = currentUser.email!

        // accessing FireBaseAuth User credentials with EmailAuthProvider
        let credential = EmailAuthProvider.credential(withEmail: currentUsersEmail, password: oldPassword)

        // Error Validation
        if newPassword.isEmpty || confirmPassword.isEmpty || oldPassword.isEmpty {
            print("Fields cannot be empty")
            self.msg = "Fields cannot be empty. Please fill out all the fields."
            self.createSuccess = false
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
            // checks if user enters the correct new password
        } else if newPassword != confirmPassword {
            print("passwords do not match")
            self.msg = "The passwords entered do not match. Please re-enter your password."
            self.createSuccess = false
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }

        } else {
            // re-authenticate user to check user password is correct
            currentUser.reauthenticate(with: credential) { _, error  in
                if error != nil {
                    print(error?.localizedDescription ?? "error reauthenticating failed")
                    self.msg = "Password entered is incorrect. Please try again"
                    self.createSuccess = false
                    withAnimation {
                        self.showBanner = true
                        self.delayAlert()
                    }
                } else {
                    // update password to db
                    print("user authentication passed")
                    currentUser.updatePassword(to: newPassword) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "password update failed")
                        } else {
                            print("Password update is successful")
                            self.msg = "Password is successfully updated!"
                            self.createSuccess = true
                            withAnimation {
                                self.showBanner = true
                                self.delayAlert()
                            }
                        }

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
