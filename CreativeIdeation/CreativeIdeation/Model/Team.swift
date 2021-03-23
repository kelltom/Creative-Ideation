//
//  Team.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-19.
//

import Foundation

struct Team: Codable, Identifiable {
    var id = UUID() // used for looping
    var teamId = ""
    var teamName = ""
    var teamDescription = ""
    var createdBy = ""
    var accessCode = ""

    var members: [String] = []
    var admins: [String] = []

    enum CodingKeys: String, CodingKey {
        case teamId
        case teamName
        case teamDescription
        case createdBy
        case accessCode
        case members
        case admins
    }
}
