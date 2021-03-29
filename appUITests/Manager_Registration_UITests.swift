//
//  Manager_Registration_UITests.swift
//  appUITests
//
//  Created by Ivan Peng on 3/29/21.
//

import XCTest

class Manager_Registration_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInvalidManagerRegistration_InvalidPassword() throws {
        let validFN = "Manager"
        let validLN = "UITest"
        let validEmail = "manageruitest@usc.edu"
        let invalidPassword = "123456789"
        let validCPassword = "absbdfbasdbfabsdfbadsb"

        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let managerButton = app.buttons["Manager"]
        XCTAssertTrue(managerButton.exists)
        managerButton.tap()

        let firstNameTextField = app.textFields["First Name.."]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(validFN)
        
        let lastNameTextField = app.textFields["Last Name.."]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(validLN)
        
        let emailTextField = app.textFields["USC Email.."]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let password = app.secureTextFields["Password.."]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(invalidPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password.."]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(validCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        let errorLabel = app.staticTexts["Passwords must match."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testInvalidManagerRegistration_InvalidEmail() throws {
        let validFN = "Manager"
        let validLN = "UITest"
        let invalidEmail = "manageruitest@gmail.com"
        let validPassword = "123456"
        let validCPassword = "123456"
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let managerButton = app.buttons["Manager"]
        XCTAssertTrue(managerButton.exists)
        managerButton.tap()

        let firstNameTextField = app.textFields["First Name.."]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(validFN)
        
        let lastNameTextField = app.textFields["Last Name.."]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(validLN)
        
        let emailTextField = app.textFields["USC Email.."]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(invalidEmail)
        
        let password = app.secureTextFields["Password.."]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(validPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password.."]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(validCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        let errorLabel = app.staticTexts["You must sign up with a USC email."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testInvalidManagerRegistration_EmptyFields() throws {
        let emptyFN = ""
        let emptyLN = ""
        let emptyEmail = ""
        let emptyPassword = ""
        let emptyCPassword = ""
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let managerButton = app.buttons["Manager"]
        XCTAssertTrue(managerButton.exists)
        managerButton.tap()

        let firstNameTextField = app.textFields["First Name.."]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(emptyFN)
        
        let lastNameTextField = app.textFields["Last Name.."]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(emptyLN)
        
        let emailTextField = app.textFields["USC Email.."]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(emptyEmail)
        
        let password = app.secureTextFields["Password.."]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(emptyPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password.."]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(emptyCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        let errorLabel = app.staticTexts["Please fill in all fields."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }

    func testValidManagerRegistration() throws {
        let validFN = "Manager"
        let validLN = "UITest"
        let validEmail = "manageruitest@usc.edu"
        let validPassword = "123456"
        let validCPassword = "123456"
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let managerButton = app.buttons["Manager"]
        XCTAssertTrue(managerButton.exists)
        managerButton.tap()

        let firstNameTextField = app.textFields["First Name.."]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(validFN)
        
        let lastNameTextField = app.textFields["Last Name.."]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(validLN)
        
        let emailTextField = app.textFields["USC Email.."]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let password = app.secureTextFields["Password.."]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(validPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password.."]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(validCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        XCTAssertTrue(app.buttons["Create Account"].exists)
        app.buttons["Create Account"].tap()
        
    }

}
