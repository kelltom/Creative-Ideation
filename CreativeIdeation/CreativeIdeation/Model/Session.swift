//
//  File.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-21.
//

import Foundation
import FirebaseFirestoreSwift

struct Session: Identifiable, Codable {
    var id = UUID()

    var sessionId = ""
    var sessionTitle = ""
    var sessionDescription = ""
    var type = "" // this should probably be an enum
    var inProgress = true
    var isVoting = false
    var dateCreated: Date = Date()
    var dateModified: Date = Date()
    var createdBy = ""
    var timerEnd: Date = Date()
    var timerActive = false

    var groupId = "" /// The group ID that this session belongs to
    var teamId = ""  /// The team ID that this session belongs to

    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionTitle
        case sessionDescription
        case type
        case inProgress
        case isVoting
        case dateCreated
        case dateModified
        case createdBy
        case timerEnd
        case timerActive
        case groupId
        case teamId
    }
}
