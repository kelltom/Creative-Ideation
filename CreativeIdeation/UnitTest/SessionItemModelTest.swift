//
//  UnitTest.swift
//  UnitTest
//
//  Created by Vanessa Li on 2021-11-22.
//

import XCTest
@testable import CreativeIdeation

class SessionItemModelTest: XCTestCase {
    var sut: SessionItemViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SessionItemViewModel()

    }

    override func tearDownWithError() throws {
      sut = nil
      try super.tearDownWithError()
    }

    func testUpdatingItemText() {
        // given
        let profanityText = "poop Blue"
        sut.sessionItems.append(SessionItem(itemId: "0"))
        sut.sessionItems.append(SessionItem(itemId: "1"))

        // when
        sut.updateText(text: profanityText, itemId: "0", filterProfanity: true)
        sut.updateText(text: profanityText, itemId: "1", filterProfanity: false)

        // then
        XCTAssertEqual(sut.sessionItems[0].input, "**** Blue", "Update text failed when filter profanity is enabled")
        XCTAssertEqual(sut.sessionItems[1].input, profanityText, "Update text failed when filter profanity is disabled")
    }

    func testCreatingStickies() {
        // given
        let itemA = SessionItem(itemId: "A")
        let itemB = SessionItem(itemId: "B")
        let itemC = SessionItem(itemId: "C")

        // when
        sut.createSticky(newItem: itemA, selected: true)
        sut.createSticky(newItem: itemB)
        sut.createSticky(newItem: itemC, selected: false, index: 0)

        // then
        XCTAssertEqual(sut.stickyNotes[0].itemId, "C", "Failed ordering given index")
        XCTAssertEqual(sut.stickyNotes[1].itemId, "A")
        XCTAssertEqual(sut.stickyNotes[1].selected, true, "Failed setting selected")
        XCTAssertEqual(sut.stickyNotes[2].itemId, "B")
    }

    func testUpdatingSelectedSticky() {
        // given
        let sticky1 = StickyNote(input: "", itemId: "B")
        sut.sessionItems.append(SessionItem(itemId: "A"))
        sut.sessionItems.append(SessionItem(itemId: "B"))

        /// when
        sut.updateSelected(note: sticky1)

        // then
        XCTAssertEqual(sut.selectedSticky?.itemId, "B", "Selected sticky is not Item B")
        XCTAssertEqual(sut.selectedItem?.itemId, "B", "Selected sticky is not Item B")
    }

    func testColoringSelectedSticky() {

    }

    func testSortingStickies() {

    }

}
