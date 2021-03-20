//
//  Group.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-03-20.
//

import Foundation

struct Group {
    
    var id = UUID() // used for looping
    var groupId = ""
    var groupTitle = ""
    var groupDescription = ""
    
    var admins: [String] = []
    var members: [String] = []
    var sessions: [String] = []
    
 
}
