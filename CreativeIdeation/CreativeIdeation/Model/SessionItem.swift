//
//  StickyItem.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-03.
//

import Foundation
import FirebaseFirestoreSwift

struct SessionItem: Identifiable, Codable, Hashable {
    var id = UUID()

    var itemId = ""
    var uid = ""
    var input = ""
    var color = 0
    var score = 0
    var haveVoted: [String] = []

    var sessionId = ""  /// The session ID that this item belongs to

    enum CodingKeys: String, CodingKey {
        case itemId
        case uid
        case input
        case color
        case score
        case sessionId
        case haveVoted
    }
}
