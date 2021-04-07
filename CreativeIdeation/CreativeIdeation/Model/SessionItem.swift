//
//  StickyItem.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-03.
//

import Foundation

struct SessionItem: Identifiable, Codable, Hashable {
    var id = UUID()

    var input = ""
    var location = [400, 400]
    var color = 0

    var sessionId = ""  /// The session ID that this item belongs to

    enum CodingKeys: String, CodingKey {
        case input
        case location
        case color
        case sessionId
    }
}
