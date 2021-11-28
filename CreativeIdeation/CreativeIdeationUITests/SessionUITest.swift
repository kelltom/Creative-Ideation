//
//  TeamsManagementUITest.swift
//  CreativeIdeationUITests
//
//  Created by Vanessa Li on 2021-11-24.
//

import XCTest

class SessionUITest: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testUICreateSession() {

        let emailAddress = app.textFields["Email Address"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let loginButton =  app.buttons["Log In"]
        emailAddress.tap()
        emailAddress.typeText("Toad123@email.com")
        emailAddress.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("abc123")
        loginButton.tap()

        // Create session
        app.scrollViews.otherElements.buttons["Add"].tap()

        let sessionNameTextField = app.textFields["Session Name"]
        sessionNameTextField.tap()
        sessionNameTextField.typeText("session 123")

        if sessionNameTextField.isSelected {
            XCTAssertTrue(sessionNameTextField.exists, "session name text field is not found")
        }
        app.buttons["Start"].tap()

     }

}
