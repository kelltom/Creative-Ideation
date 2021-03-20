//
//  Team.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-19.
//

import Foundation

struct Team {
    var teamId = ""
    var teamName = ""
    var teamDescription = ""
    var createdBy = ""
    var accessCode = ""
    
    var members: [String] = []
    var admins: [String] = []
}
