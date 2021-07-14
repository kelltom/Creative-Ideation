//
//  Team.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-19.
//

import Foundation
import FirebaseFirestoreSwift

struct Team: Codable, Identifiable, Equatable {
    var id = UUID() // used for looping
    var teamId = ""
    var teamName = ""
    var teamDescription = ""
    var createdBy = ""
    var accessCode = ""
    var isPrivate = false

    var members: [String] = []
    var admins: [String] = []

    var dateCreated: Date = Date()

    enum CodingKeys: String, CodingKey {
        case teamId
        case teamName
        case teamDescription
        case createdBy
        case accessCode
        case isPrivate
        case members
        case admins
        case dateCreated
    }
}
