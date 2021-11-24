//
//  UserAccountProtocol.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-11-22.
//

import Foundation

protocol UserAccountProtocol {
    func authenticate(email: String, password: String)
}
