//
//  SessionSettings.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-10-01.
//

import Foundation
import FirebaseFirestoreSwift

struct SessionSettings: Identifiable, Codable, Hashable {
    var id = UUID()

    var settingsId = "69"
    var sessionId = ""
    var displayTimer = true
    var timerSetting = 600
    var displayScore = true
    var deleteStickies = false
    var topStickiesCount = 6
    var filterProfanity = true

    enum CodingKeys: String, CodingKey {
        case settingsId
        case sessionId
        case displayTimer
        case timerSetting
        case displayScore
        case deleteStickies
        case topStickiesCount
        case filterProfanity
    }
}
