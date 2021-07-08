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

struct Member: Codable, Identifiable, Hashable {
    let memberId = UUID()
    let id: String = ""
    let name: String = ""
    let email: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
    }
}
