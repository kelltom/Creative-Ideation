//
//  Group.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-20.
//

import Foundation

struct Group: Codable, Identifiable {
    
    var id = UUID() // used for looping
    var groupId = ""
    var groupTitle = ""
    
    var admins: [String] = []
    var members: [String] = []
    var sessions: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case groupId
        case groupTitle
        case admins
        case members
        case sessions
    }
 
}
