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
    @Published var updateSuccess = false
    @Published var logOutFlag = false
    @Published var isLoading = false
    @Published var selectedUser: User?
    @Published var msg: String = ""

    @Published var showBanner = false
    @Published var bannerData: BannerModifier.BannerData =
        BannerModifier.BannerData(title: "Default Title",
                                  detail: "Default detail message.",
                                  type: .info)

    func authenticate(email: String, password: String) {
        self.showBanner = false
        self.isLoading = true

        // Populate User object
        var user = User()
        user.email = email
        user.password = password

        // Authenticate user credentials
        Auth.auth().signIn(withEmail: user.email, password: user.password) { (_, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
                self.isLoading = false
                self.msg = error?.localizedDescription ?? ""
                self.authSuccess = false
            } else {
                print("Success")
                self.isLoading = false
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
            if authSuccess {
                self.authSuccess = false
            } else if createSuccess {
                self.createSuccess = false
            }
            self.showBanner = false
            print("signed out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    /// Populates selectedUser attribute
    func getCurrentUserInfo() { // reading the database onAppear in UpdateEmailSettings
        self.showBanner = false
        guard let uid = Auth.auth().currentUser?.uid else {
            print("getCurrentUserInfo: failed to find uid")
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
                        print("User Settings: User object mapped successfully")
                    } catch {
                        print("User Settings: Error creating object to User")
                    }
                }
            }
    }

    /// updating user name to  db
    func updateUserName(name: String) {
        self.isLoading = true

        // Get user ID
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Could not find signed-in user's ID")
            return
        }

        var user = User()
        user.name = name
        let oldName = self.selectedUser?.name

        // Error Validation
        if name.isEmpty {
            self.isLoading = false
            self.updateSuccess = false

            // Set banner
            setBannerData(title: "Cannot change name", details: "New name cannot be empty", type: .warning)
            self.showBanner = true
        } else if name == oldName {
            self.isLoading = false
            self.updateSuccess = false

            // Set banner
            self.setBannerData(title: "Cannot change name", details: "New name cannot be the same as current name.", type: .warning)
            self.showBanner = true
        } else {
            // query db and update name in the document
            db.collection("users").document(uid).updateData([
                "name": user.name
            ]) { err in
                if let err = err {
                    self.isLoading = false
                    self.updateSuccess = false

                    // Set banner
                    self.setBannerData(title: "Cannot change name", details: "Error updating user name. Please contact your admin. \(err)", type: .error)
                    self.showBanner = true

                    print("updateUserName: Error updating user name")
                } else {
                    self.isLoading = false
                    self.updateSuccess = true
                    self.selectedUser?.name = user.name  // update view

                    // Set banner
                    self.setBannerData(title: "Success", details: "Name updated successfully!", type: .success)
                    self.showBanner = true

                    print("updateUserName: User name updated successfully")
                }
            }
        }
    }

    /// Updates user's email with input
    func updateUserEmail(email: String, password: String) {
        self.isLoading = true

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

        // reauthenticating user for email change
        let credential = EmailAuthProvider.credential(withEmail: oldEmail, password: password)

        // Error checking before updating to DB
        if email.isEmpty || password.isEmpty {
            self.isLoading = false
            self.msg = "Email or password cannot be empty"
            self.updateSuccess = false
            // Display results to View
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
            print("Update failed: Email or password cannot be empty")

        } else if oldEmail.lowercased() == user.email.lowercased() {
            self.isLoading = false
            self.msg = "Email cannot be same as previous email"
            self.updateSuccess = false
            // Display results to View
            withAnimation {
                self.showBanner = true
                self.delayAlert()
            }
            print("Update failed: Email cannot be same as old email")

        } else {
            currentUser.reauthenticate(with: credential) { _, error in
                if error != nil {
                    self.isLoading = false
                    self.msg = "Password entered is incorrect. Try again."
                    self.updateSuccess = false
                    withAnimation {
                        self.showBanner = true
                        self.delayAlert()
                    }
                    print("Update failed: password entered is incorrect")
                } else {
                    // Update email to auth
                    currentUser.updateEmail(to: email) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "Email update failed")
                            self.isLoading = false
                            self.msg = error?.localizedDescription ?? "Error updating email"
                            self.updateSuccess = false
                        } else {
                            // Updates email address in corresponding document collection
                            self.db.collection("users").document(uid).updateData([
                                "email": user.email
                            ]) { err in
                                if let err = err {
                                    print("Error updating user email: \(err)")
                                    self.msg = "Error updating user email  \(err)"
                                    self.isLoading = false
                                    self.updateSuccess = false
                                    // Display result to View
                                    withAnimation {
                                        self.showBanner = true
                                        self.delayAlert()
                                    }
                                } else {
                                    print("User email updated successfully")
                                    self.isLoading = false
                                    self.msg = "Email updated successfully!"
                                    self.updateSuccess = true
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
        }
    }

    func updateUserPassword(newPassword: String, confirmPassword: String, oldPassword: String) {
        self.isLoading = true

        // Get current user
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let currentUsersEmail = currentUser.email!

        // accessing FireBaseAuth User credentials with EmailAuthProvider
        let credential = EmailAuthProvider.credential(withEmail: currentUsersEmail, password: oldPassword)

        // Error Validation
        if newPassword.isEmpty || confirmPassword.isEmpty || oldPassword.isEmpty {
            self.isLoading = false
            self.updateSuccess = false

            // Set Banner
            self.setBannerData(title: "Cannot change password", details: "Fields cannot be empty. Please fill out all the fields.", type: .warning)
            self.showBanner = true

            print("Fields cannot be empty")
        // checks if user enters the correct new password
        } else if newPassword != confirmPassword {
            self.isLoading = false
            self.updateSuccess = false

            // Set Banner
            self.setBannerData(title: "Cannot change password", details: "New passwords do not match. Please re-enter your password.", type: .warning)
            self.showBanner = true

            print("passwords do not match")
        } else {
            // re-authenticate user to check user password is correct
            currentUser.reauthenticate(with: credential) { _, error  in
                if error != nil {
                    self.isLoading = false
                    self.updateSuccess = false

                    // Set Banner
                    self.setBannerData(title: "Cannot change password", details: "Password entered is incorrect. Please try again.", type: .warning)
                    self.showBanner = true

                    print(error?.localizedDescription ?? "error reauthenticating failed")
                } else {
                    // update password to db
                    currentUser.updatePassword(to: newPassword) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "password update failed")
                        } else {
                            print("Password update is successful")
                            self.isLoading = false
                            self.updateSuccess = true
                            self.logOutFlag = true

                            // Set Banner
                            self.setBannerData(title: "Success",
                                               details: "Password is successfully updated!",
                                               type: .success)
                            self.showBanner = true
                        }
                    }
                }
            }
        }
    }

    func createAccount(name: String, email: String, password: String) {
        self.showBanner = false
        self.isLoading = true

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
                self.isLoading = false
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
                        self.isLoading = false
                        self.msg = "Error adding document: \(err)"
                        self.createSuccess = false
                    } else {
                        print("Document added with")
                        self.isLoading = false
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showBanner = false
            }
        }
    }

    /// Assigns values to the published BannerData object
    private func setBannerData(title: String, details: String, type: BannerModifier.BannerType) {
        bannerData.title = title
        bannerData.detail = details
        bannerData.type = type
    }
}
