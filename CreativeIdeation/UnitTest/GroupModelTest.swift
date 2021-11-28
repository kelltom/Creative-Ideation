//
//  GroupModelTest.swift
//  UnitTest
//
//  Created by Vanessa Li on 2021-11-23.
//

import XCTest
@testable import CreativeIdeation
import SwiftUI

class GroupModelTest: XCTestCase {
    var sut: GroupViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = GroupViewModel()

    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testSplitGroupMembers() {
        // given
        let teamMember = [Member(id: "A"), Member(id: "B"), Member(id: "C"), Member(id: "D"), Member(id: "E"), Member(id: "F")]
        let groupMember = ["A", "C", "D"]
        let nonMember = ["B", "E", "F"]
        sut.selectedGroup = Group(members: groupMember)

        // when
        sut.splitMembers(teamMembers: teamMember)

        // then
        for member in sut.nonMembers {
            XCTAssertTrue(nonMember.contains(member.id), "member id not in NonMembers")
        }

        for member in sut.groupMembers {
            XCTAssertTrue(groupMember.contains(member.id), "member id not in GroupMembers")
        }
    }
}
