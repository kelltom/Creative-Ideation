//
//  File.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-21.
//

import Foundation

struct Session: Identifiable, Codable {
    var id = UUID()

    var sessionId = ""
    var sessionTitle = ""
    var sessionDescription = ""
    var type = "" // this should probably be an enum
    var inProgress = true
    var dateCreated = "" // should probably be some time of datetime object
    var dateModified = ""
    var createdBy = ""

    var groupId = "" /// The group ID that this session belongs to
    var teamId = ""  /// The team ID that this session belongs to

    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionTitle
        case sessionDescription
        case type
        case inProgress
        case dateCreated
        case dateModified
        case createdBy
        case groupId
        case teamId
    }
}
