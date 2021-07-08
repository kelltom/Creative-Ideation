//
//  StickyItem.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-04-03.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct SessionItem: Identifiable, Codable, Hashable {
    var id = UUID()

    var itemId = ""
    var input = ""
    var location: [Int] = [400, 400]
    var color = 0

    var sessionId = ""  /// The session ID that this item belongs to

    enum CodingKeys: String, CodingKey {
        case itemId
        case input
        case location
        case color
        case sessionId
    }
}
