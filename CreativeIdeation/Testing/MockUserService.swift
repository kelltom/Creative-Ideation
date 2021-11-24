//
//  MockUserService.swift
//  CreativeIdeation
//
//  Created by Vanessa Li on 2021-11-22.
//

final class MockUserService: UserService {
    func authenticate(email: String, password: String) {
        var authSuccess = true
        if !email.isEmpty && !password.isEmpty {
            authSuccess = true
        } else {
            authSuccess = false
        }
    }
}
