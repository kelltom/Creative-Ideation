//
//  LoginUITest.swift
//  CreativeIdeationUITests
//
//  Created by Vanessa Li on 2021-11-24.
//

import XCTest

class UserAccountManagement: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testUILogin() {
        // given
        let emailAddress = app.textFields["Email Address"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let loginButton =  app.buttons["Log In"]
        emailAddress.tap()
        emailAddress.typeText("Toad@email.com")
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("abc123")

        if emailAddress.isSelected && passwordSecureTextField.isSelected {
            XCTAssertTrue(emailAddress.exists)
            XCTAssertTrue(passwordSecureTextField.exists)

        }

        loginButton.tap()
        if loginButton.isSelected {
            XCTAssertTrue(loginButton.exists)
        }

    }

    func testUICreateAccount() {
        // given
        let fullName = app.textFields["Full Name"]
        let emailAddressTextField = app.textFields["Email Address"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let createAccountButton = app.buttons["Create Account"]
        let createAnAcc =  app.buttons["Create an Account."]

        // then
        createAnAcc.tap()
        fullName.tap()
        fullName.typeText("New User")
        emailAddressTextField.tap()
        emailAddressTextField.typeText("new@email.com")
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("abc123")

        // then
        if fullName.isSelected  &&  emailAddressTextField.isSelected && passwordSecureTextField.isSelected {
            XCTAssertTrue(fullName.exists, "cannot get full name text field")
            XCTAssertTrue(emailAddressTextField.exists, "cannot get email address text field")
            XCTAssertTrue(passwordSecureTextField.exists, "cannot get password text field")
        }

        createAccountButton.tap()

        if createAccountButton.isSelected {
            XCTAssertTrue(createAccountButton.exists)
        }

    }
}
