//
//  File.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-21.
//

import Foundation

struct Session {
    var sessionId = ""
    var sessionTitle = ""
    var sessionDescription = ""
    var fkGroupId = "" /// The group ID that this session belongs to
    var type = "" // this should probably be an enum
    var inProgress = true
    var dateCreated = "" // should probably be some time of datetime object
    var dateModified = ""
    var createdBy = ""
}
