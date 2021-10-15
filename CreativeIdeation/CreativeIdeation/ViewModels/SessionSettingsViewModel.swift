//
//  SessionSettingsViewModel.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-01.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

final class SessionSettingsViewModel: ObservableObject {

    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?

    @Published var settings = [SessionSettings()]
    @Published var textTime = "10"
    @Published var textTopStickies = "6"

    func clear() {
        listener?.remove()
        settings = [SessionSettings()]
    }

    func createSettings(sessionId: String) {
        // Save new SessionSettings to DB - using batch
        let settingsRef = db.collection("session_settings").document()

        settingsRef.setData([
            "settingsId": settingsRef.documentID,
            "sessionId": sessionId,
            "displayTimer": true,
            "timerSetting": 600,
            "displayScore": true,
            "deleteStickies": false,
            "topStickiesCount": 6,
            "filterProfanity": true
        ]) { err in
            if let err = err {
                print("Error creating SessionSettings")
            } else {
                print("SessionSettings successfully created")
            }
        }
    }

    func loadSettings(sessionId: String) {
        // Clear settings to remove old data
        print("Loading from sessionID: ", sessionId)
        settings = [SessionSettings()]

        listener = db.collection("session_settings").whereField("sessionId", in: [sessionId])
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        // Add new item locally
                        print("ADDING")
                        do {
                            let newSettings = try (diff.document.data(as: SessionSettings.self)!)
                            self.settings.append(newSettings)
                        } catch {
                            print("Error reading settings from DB: \(error)")
                        }
                    }
                    if diff.type == .modified {
                        // Modify local item
                        do {
                            let mockSettings = try (diff.document.data(as: SessionSettings.self)!)

                            self.settings[1].displayTimer = mockSettings.displayTimer
                            self.settings[1].timerSetting = mockSettings.timerSetting
                            self.settings[1].displayScore = mockSettings.displayScore
                            self.settings[1].deleteStickies = mockSettings.deleteStickies
                            self.settings[1].topStickiesCount = mockSettings.topStickiesCount
                            self.settings[1].filterProfanity = mockSettings.filterProfanity

                            self.textTime = String(mockSettings.timerSetting / 60)
                            self.textTopStickies = String(mockSettings.topStickiesCount)

                        } catch {
                            print("Error reading modified settings from DB: \(error)")
                        }
                    }
                    if diff.type == .removed {
                        self.settings = [SessionSettings()]
                    }
                }
            }
    }

    func toggleTimer() {
        let settingsReference = db.collection("session_settings").document(settings.last!.settingsId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(settingsReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            transaction.updateData(["displayTimer": self.settings.last!.displayTimer],
                                   forDocument: settingsReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating display timer settings: \(error)")
            }
        }
    }

    func toggleScore() {
        let settingsReference = db.collection("session_settings").document(settings.last!.settingsId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(settingsReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            transaction.updateData(["displayScore": self.settings.last!.displayScore],
                                   forDocument: settingsReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating display score settings: \(error)")
            }
        }
    }

    func toggleDelete() {
        let settingsReference = db.collection("session_settings").document(settings.last!.settingsId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(settingsReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            transaction.updateData(["deleteStickies": self.settings.last!.deleteStickies],
                                   forDocument: settingsReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating delete sticky settings: \(error)")
            }
        }
    }

    func toggleProfanity() {
        let settingsReference = db.collection("session_settings").document(settings.last!.settingsId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(settingsReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            transaction.updateData(["filterProfanity": self.settings.last!.filterProfanity],
                                   forDocument: settingsReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating filter profanity settings: \(error)")
            }
        }
    }

    func updateTime() {
        let newTime = Int(textTime)! * 60

        let settingsReference = db.collection("session_settings").document(settings.last!.settingsId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(settingsReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            transaction.updateData(["timerSetting": newTime],
                                   forDocument: settingsReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating timer settings: \(error)")
            }
        }
    }

    func updateTopStickyCount() {
        let newCount = Int(textTopStickies) ?? 6

        let settingsReference = db.collection("session_settings").document(settings.last!.settingsId)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            do {
                _ = try transaction.getDocument(settingsReference)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            transaction.updateData(["topStickiesCount": newCount],
                                   forDocument: settingsReference)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error updating deletion settings: \(error)")
            }
        }
    }
}
