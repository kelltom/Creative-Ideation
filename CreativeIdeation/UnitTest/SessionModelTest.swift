//
//  UserModelTest.swift
//  UnitTest
//
//  Created by Vanessa Li on 2021-11-23.
//

import XCTest
@testable import CreativeIdeation

class SessionModelTest: XCTestCase {
    var sut: SessionViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SessionViewModel()

    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }

    func testBestIds() {
        // given
        sut.selectedSession = Session(inProgress: true)
        sut.selectedSession!.finalVotes = ["A": 1, "B": 5, "C": 2, "D": 1]

        // when
        var result1 = sut.getBestIds()

        // given
        sut.selectedSession = Session(inProgress: true)
        sut.selectedSession!.finalVotes = ["A": 1, "B": 5, "C": 5, "D": 1]

        // when
        var result2 = sut.getBestIds()

        // then
        XCTAssertEqual(result1, ["B"], "failed to get top list" )
        XCTAssertEqual(result2, ["B", "C"], "failed to detect tie in best votes" )
    }

}
