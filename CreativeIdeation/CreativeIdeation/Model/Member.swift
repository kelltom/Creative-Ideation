//
//  Member.swift
//  CreativeIdeation
//
//  Created by Matthew Marini on 2021-06-06.
//

import Foundation

struct Member: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String = ""
    let email: String = ""

    enum CodingKeys: String, CodingKey {
        case name
        case email
    }
}
