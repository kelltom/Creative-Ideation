//
//  TeamModelTest.swift
//  UnitTest
//
//  Created by Vanessa Li on 2021-11-23.
//

import XCTest
@testable import CreativeIdeation

class TeamModelTest: XCTestCase {
    var sut: TeamViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TeamViewModel()

    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }

    func testIsCurrentUserTeamAdmin() {
        // given
        let teamId = "1"
        sut.teams = [Team(teamId: "1", admins: ["A"]), Team(teamId: "2", admins: ["B"])]

        // when
        var result = sut.isCurrentUserTeamAdmin(teamId: teamId)
        result = sut.teams[0].admins.contains("A")

        // then
        XCTAssertEqual(result, true)
    }

}
