//
//  User.swift
//  CreativeIdeation
//
//  Created by Kellen Evoy on 2021-03-17.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    var userId = UUID()
   // @DocumentID var id = UUID()
    var id = ""
    var name = ""
    var email = ""
    var password = ""

    var teams: [String] = []

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case teams

    }
}
