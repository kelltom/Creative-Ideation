//
//  Member.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-06-06.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Member: Codable, Identifiable, Equatable, Hashable {
    var memberId = UUID()
    var id = ""
    var name = ""
    var email = ""

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
}
