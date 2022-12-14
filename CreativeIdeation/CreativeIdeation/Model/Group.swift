//
//  Group.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-20.
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Codable, Identifiable, Equatable {
    var id = UUID()  // used for looping
    var groupId = ""
    var groupTitle = ""
    var fkTeamId = ""

    var admins: [String] = []
    var members: [String] = []
    var sessions: [String] = []

    var dateCreated: Date = Date()

    var isPublic: Bool = false

    enum CodingKeys: String, CodingKey {
        case groupId
        case groupTitle
        case fkTeamId
        case admins
        case members
        case sessions
        case dateCreated
        case isPublic
    }

}
