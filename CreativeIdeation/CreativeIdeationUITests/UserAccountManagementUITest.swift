//
//  LoginUITest.swift
//  CreativeIdeationUITests
//
//  Created by Vanessa Li on 2021-11-24.
//

import XCTest

class UserAccountManagementUITest: XCTestCase {
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
        emailAddress.typeText("Toad123@email.com")
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

    func testUpdateUserAccountInformation() {
        // given
        let emailAddress = app.textFields["Email Address"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let loginButton =  app.buttons["Log In"]
        emailAddress.tap()
        emailAddress.typeText("Toad123@email.com")
        emailAddress.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("abc123")
        loginButton.tap()

        // recorded navigation element
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .button).element(boundBy: 4).tap()
        element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 0).tap()

        let enterNewNameTextField = app.textFields["Enter New Name "]
        enterNewNameTextField.tap()
        enterNewNameTextField.typeText("Toad Toads")

        let submitButton = app.buttons["Submit"]
        submitButton.tap()

        // NEW NAME
        if enterNewNameTextField.isSelected {
            XCTAssertTrue(enterNewNameTextField.exists, " enter new name text field not found")
        }

        let closeButton = app.buttons["Close"]
        closeButton.tap()
        element.children(matching: .button).matching(identifier: "Edit").element(boundBy: 1).tap()

        // NEW EMAIL
        let enterNewEmailTextField = app.textFields["Enter New Email "]
        enterNewEmailTextField.tap()
        enterNewEmailTextField.typeText("toad@email.com")

        let enterPasswordToConfirmSecureTextField = app.secureTextFields["Enter Password to Confirm "]
        enterPasswordToConfirmSecureTextField.tap()
        enterPasswordToConfirmSecureTextField.typeText("abc123")

        // then
        if enterNewEmailTextField.isSelected && enterPasswordToConfirmSecureTextField.isSelected {
            XCTAssertTrue(enterNewEmailTextField.exists, " enter new email text field not found")
            XCTAssertTrue(enterPasswordToConfirmSecureTextField.exists, " enter password text field not found")
        }
        submitButton.tap()
        closeButton.tap()

    }

}
