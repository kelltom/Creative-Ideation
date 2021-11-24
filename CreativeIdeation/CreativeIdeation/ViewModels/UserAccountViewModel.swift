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
import Profanity_Filter
import FirebaseStorage

final class UserAccountViewModel: ObservableObject {

    // private var dbService : DBService!
    private var db = Firestore.firestore()
    private var pFilter = ProfanityFilter()
    private var manager = LocalFileManager.instance
    private var retreivedImage: UIImage?
    private var folderName = "profile_picture"

    @Published var authSuccess = false
    @Published var createSuccess = false
    @Published var updateSuccess = false
    @Published var logOutFlag = false
    @Published var isLoading = false
    @Published var selectedUser: User?
    @Published var userProfilePicture: Image!
    @Published var isUploadSuccess: Bool = false

    @Published var showBanner = false
    @Published var bannerData: BannerModifier.BannerData =
    BannerModifier.BannerData(title: "Default Title",
                              detail: "Default detail message.",
                              type: .info)

    func authenticate(email: String, password: String) {
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
                self.authSuccess = false

                // Set banner
                self.setBannerData(title: "Cannot authenticate",
                                   details: "Cannot authenticate credentials. \(error?.localizedDescription ?? "Unknown error.")",
                                   type: .error)
                self.showBanner = true
            } else {
                self.isLoading = false
                self.authSuccess = true

                // Set banner
                self.setBannerData(title: "Success",
                                   details: "Authenticated credentials successfully.",
                                   type: .success)
                self.showBanner = true
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
            setBannerData(title: "Cannot change name",
                          details: "New name cannot be empty",
                          type: .warning)
            self.showBanner = true
        } else if name == oldName {
            self.isLoading = false
            self.updateSuccess = false

            // Set banner
            self.setBannerData(title: "Cannot change name",
                               details: "New name cannot be the same as current name.",
                               type: .warning)
            self.showBanner = true
        } else if pFilter.containsProfanity(text: name).profanities.count > 0 {
            self.isLoading = false
            self.updateSuccess = false

            // Set Banner
            setBannerData(title: "Cannot change name",
                          details: "New name cannot contain profanity.",
                          type: .warning)
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
                    self.setBannerData(title: "Cannot change name",
                                       details: "Error updating user name. Please contact your admin. \(err)",
                                       type: .error)
                    self.showBanner = true

                    print("updateUserName: Error updating user name")
                } else {
                    self.isLoading = false
                    self.updateSuccess = true
                    self.selectedUser?.name = user.name  // update view

                    // Set banner
                    self.setBannerData(title: "Success",
                                       details: "Name updated successfully!",
                                       type: .success)
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
            self.updateSuccess = false

            // Set Banner
            self.setBannerData(title: "Cannot change email",
                               details: "Email or password cannot be empty.",
                               type: .warning)
            self.showBanner = true

            print("Update failed: Email or password cannot be empty")

        } else if oldEmail.lowercased() == user.email.lowercased() {
            self.isLoading = false
            self.updateSuccess = false

            // Set Banner
            self.setBannerData(title: "Cannot change email",
                               details: "Email cannot be same as previous email.",
                               type: .warning)
            self.showBanner = true

            print("Update failed: Email cannot be same as old email")

        } else {
            currentUser.reauthenticate(with: credential) { _, error in
                if error != nil {
                    self.isLoading = false
                    self.updateSuccess = false

                    // Set Banner
                    self.setBannerData(title: "Cannot change email",
                                       details: "Password entered is incorrect. Try again.",
                                       type: .warning)
                    self.showBanner = true

                    print("Update failed: password entered is incorrect")
                } else {
                    // Update email to auth
                    currentUser.updateEmail(to: email) { error in
                        if error != nil {
                            print(error?.localizedDescription ?? "Email update failed")
                            self.isLoading = false
                            let err = error?.localizedDescription ?? "Error updating email"
                            self.updateSuccess = false

                            // Set Banner
                            self.setBannerData(title: "Email update failed",
                                               details: "Failed to update email. Ensure you are connected to the internet. Error: \(err)",
                                               type: .error)
                            self.showBanner = true
                        } else {
                            // Updates email address in corresponding document collection
                            self.db.collection("users").document(uid).updateData([
                                "email": user.email
                            ]) { err in
                                if let err = err {
                                    print("Error updating user email: \(err)")
                                    self.isLoading = false
                                    self.updateSuccess = false

                                    // Set Banner
                                    self.setBannerData(title: "Email update failed",
                                                       details: "Failed to update email. Ensure you are connected to the internet. Error: \(err)",
                                                       type: .error)
                                    self.showBanner = true
                                } else {
                                    print("User email updated successfully")
                                    self.isLoading = false
                                    self.updateSuccess = true
                                    self.selectedUser?.email = user.email

                                    // Set Banner
                                    self.setBannerData(title: "Success",
                                                       details: "Email updated successfully!",
                                                       type: .success)
                                    self.showBanner = true
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
            self.setBannerData(title: "Cannot change password",
                               details: "Fields cannot be empty. Please fill out all the fields.",
                               type: .warning)
            self.showBanner = true

            print("Fields cannot be empty")
            // checks if user enters the correct new password
        } else if newPassword != confirmPassword {
            self.isLoading = false
            self.updateSuccess = false

            // Set Banner
            self.setBannerData(title: "Cannot change password",
                               details: "New passwords do not match. Please re-enter your password.",
                               type: .warning)
            self.showBanner = true

            print("passwords do not match")
        } else {
            // re-authenticate user to check user password is correct
            currentUser.reauthenticate(with: credential) { _, error  in
                if error != nil {
                    self.isLoading = false
                    self.updateSuccess = false

                    // Set Banner
                    self.setBannerData(title: "Cannot change password",
                                       details: "Password entered is incorrect. Please try again.",
                                       type: .warning)
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

        if pFilter.containsProfanity(text: name).profanities.count > 0 {
            self.setBannerData(title: "Error creating account",
                               details: "Cannot use profanity in your name.",
                               type: .warning)
            self.showBanner = true
            self.isLoading = false
            self.createSuccess = false
            return
        }

        // Populate User object
        var user = User()
        user.name = name
        user.email = email
        user.password = password

        // Add new User to authenticated list
        Auth.auth().createUser(withEmail: user.email, password: user.password) { authResult, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error creating account")
                self.isLoading = false
                self.createSuccess = false

                // Set banner
                self.setBannerData(title: "Error creating account",
                                   details: "Error: \(error?.localizedDescription ?? "unknown")",
                                   type: .error)
                self.showBanner = true

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
                        self.createSuccess = false

                        // Set banner
                        self.setBannerData(title: "Error creating account",
                                           details: "We've encountered an error trying to create your account. Make sure you're connected to the internet and try again. Error: \(err.localizedDescription)",
                                           type: .error)
                        self.showBanner = true
                    } else {
                        print("Document added with")
                        self.isLoading = false
                        self.createSuccess = true

                        // Set banner
                        self.setBannerData(title: "Success",
                                           details: "Your account has been successfully created!",
                                           type: .success)
                        self.showBanner = true
                    }
                }
            }
        }
    }

    func uploadImageToFirebase(selectedImage: UIImage, imageID: String) {

        if let imageData = selectedImage.jpegData(compressionQuality: 1) { // returnign image as jpeg
            let storage = Storage.storage()
            storage.reference().child(imageID).putData(imageData, metadata: nil) {
                (_, err) in
                if let err = err {
                    print("Error in uploading profile picture has occured \(err.localizedDescription)")
                } else {
                    self.isLoading = false
                    self.saveImageToFileManager(inputImage: selectedImage, imageID: imageID, folderName: self.folderName)
                    self.userProfilePicture = Image(uiImage: selectedImage)
                    print("Upload profile picture is success")
                }
            }
        }

    }
    func downloadImageFromFirebase() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Failed to get uid from downloading image")
            return
        }

        let storageReference = Storage.storage().reference().child(uid)
        storageReference.getData(maxSize: 5184 * 2456) { (imageData, error) in
            if let error = error {
                print("Error in getting image occured \(error.localizedDescription)")
                self.userProfilePicture = nil
            } else {
                if let imageData = imageData {
                    // assign to value
                    let img = UIImage(data: imageData)
                    self.userProfilePicture = Image(uiImage: img!)
                    print("Downloading image success, Image with this user exists")
                } else {
                    print("Not able to set to UIImage")
                }
            }
        }
    }

    func saveImageToFileManager(inputImage: UIImage, imageID: String, folderName: String) {
        // Calling the local file manager instance to save to FM
        manager.saveImagetoFileManager(image: inputImage, imageName: imageID, folderName: folderName)
        self.userProfilePicture = Image(uiImage: inputImage) // set pfp
    }
    
//    func removeFromFileManager(){
//        guard let currentUserPfp = selectedUser?.id else {
//            return
//        }
//        manager.deleteImage(imageName: currentUserPfp, folderName: self.folderName)
//        print("delete success")
//    }

    func getImageFromFileManager() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("FM - not able to get uid image from file manager")
            return
        }

        if let savedImage = manager.getImage(imageName: uid, folderName: self.folderName) {
            print("Retrieved from file manager")
            self.userProfilePicture = Image(uiImage: savedImage)
        } else {
            downloadImageFromFirebase()
            if self.userProfilePicture == nil {
                print("User has not selected a profile picture")
                self.userProfilePicture = nil
            }

        }
    }

    func deleteImage() {
        guard let profileImageId = selectedUser?.id else {
            return
        }
        // Create a reference to the file to delete
        let imageRef = Storage.storage().reference().child(profileImageId)
        
        // Delete the file
        imageRef.delete { error in
            if error != nil {
                print("failed deleting user profile pic from firebase storage")
            } else {
                // once image from firebase storage is removed successfully also remove it from file manager
                self.manager.deleteImage(imageName: profileImageId, folderName: self.folderName)
                print("successfully deleted user profile pic from firebase storage")
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
