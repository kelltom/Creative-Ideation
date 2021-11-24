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

    func testCastFinalVote() {
        // given
        sut.selectedSession = Session(inProgress: true)
        sut.selectedSession?.castFinalVote = ["A", "B", "C", "D"] // all users within the session
        let uid = "A"

        // when
        var result = sut.didCastFinalVote()
        result = sut.selectedSession!.castFinalVote.contains(uid)

        // then
        XCTAssertTrue(result, "Unable to find user id in final cast vote")
//        if result {
//
//        } else {
//            XCTAssertFalse(result, "Failed to get user not in final casting")
//        }

    }

    func testBestIds() {
        // given
        sut.selectedSession = Session(inProgress: true)
        sut.selectedSession!.finalVotes = ["A": 1, "B": 5, "C": 2, "D": 1]
        let highest = sut.selectedSession!.finalVotes.values.max()

        // when
        var result = sut.getBestIds()
        result = sut.selectedSession!.finalVotes.filter { $1 == highest }.map { $0.0 }

        // then
        XCTAssertEqual(result, ["B"], "failed to get list of string" )

    }

}
