//
//  Student_Registration_UITests.swift
//  appUITests
//
//  Created by Ivan Peng on 3/29/21.
//

import XCTest

class Student_Registration_UITests: XCTestCase {

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
    
    func testInvalidStudentRegistration_InvalidPassword() throws {
        let validFN = "Student"
        let validLN = "UITest"
        let validEmail = "studentuitest@usc.edu"
        let invalidPassword = "123"
        let validCPassword = "123456"
        let validID = "123456789"
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let studentButton = app.buttons["Student"]
        XCTAssertTrue(studentButton.exists)
        studentButton.tap()

        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(validFN)
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(validLN)
        
        let emailTextField = app.textFields["USC Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(invalidPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password"]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(validCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let ID = app.textFields["USC Student ID"]
        XCTAssertTrue(ID.exists)
        ID.tap()
        ID.typeText(validID)
        
        returnButton.tap()
        let majorTextField = app.textFields["Major"]
        XCTAssertTrue(majorTextField.exists)
        majorTextField.tap()

        
        app/*@START_MENU_TOKEN@*/.pickerWheels["Aerospace Engineering"]/*[[".pickers.pickerWheels[\"Aerospace Engineering\"]",".pickerWheels[\"Aerospace Engineering\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        let errorLabel = app.staticTexts["Passwords must match."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testInvalidStudentRegistration_InvalidEmail() throws {
        let validFN = "Student"
        let validLN = "UITest"
        let invalidEmail = "studentuitest@gmail.com"
        let validPassword = "123456"
        let validCPassword = "123456"
        let validID = "123456789"
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let studentButton = app.buttons["Student"]
        XCTAssertTrue(studentButton.exists)
        studentButton.tap()

        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(validFN)
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(validLN)
        
        let emailTextField = app.textFields["USC Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(invalidEmail)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(validPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password"]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(validCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let ID = app.textFields["USC Student ID"]
        XCTAssertTrue(ID.exists)
        ID.tap()
        ID.typeText(validID)
        
        returnButton.tap()
        let majorTextField = app.textFields["Major"]
        XCTAssertTrue(majorTextField.exists)
        majorTextField.tap()

        
        app/*@START_MENU_TOKEN@*/.pickerWheels["Aerospace Engineering"]/*[[".pickers.pickerWheels[\"Aerospace Engineering\"]",".pickerWheels[\"Aerospace Engineering\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        let errorLabel = app.staticTexts["You must sign up with a USC email."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testInvalidStudentRegistration_EmptyFields() throws {
        let emptyFN = ""
        let emptyLN = ""
        let emptyEmail = ""
        let emptyPassword = ""
        let emptyCPassword = ""
        let emptyID = ""
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let studentButton = app.buttons["Student"]
        XCTAssertTrue(studentButton.exists)
        studentButton.tap()

        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(emptyFN)
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(emptyLN)
        
        let emailTextField = app.textFields["USC Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(emptyEmail)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(emptyPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password"]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(emptyCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let ID = app.textFields["USC Student ID"]
        XCTAssertTrue(ID.exists)
        ID.tap()
        ID.typeText(emptyID)
        
        returnButton.tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        let errorLabel = app.staticTexts["Please fill in all fields."]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: errorLabel, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
    }

    func testValidStudentRegistration() throws {
        let validFN = "Student"
        let validLN = "UITest"
        let validEmail = "studentuitest@usc.edu"
        let validPassword = "123456"
        let validCPassword = "123456"
        let validID = "123456789"
        
        let app = XCUIApplication()
        app.launch()
        
        let signUpButton = app/*@START_MENU_TOKEN@*/.staticTexts["Sign up"]/*[[".buttons[\"Sign up\"].staticTexts[\"Sign up\"]",".staticTexts[\"Sign up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(signUpButton.exists)
        signUpButton.tap()
        
        let studentButton = app.buttons["Student"]
        XCTAssertTrue(studentButton.exists)
        studentButton.tap()

        let firstNameTextField = app.textFields["First Name"]
        XCTAssertTrue(firstNameTextField.exists)
        firstNameTextField.tap()
        firstNameTextField.typeText(validFN)
        
        let lastNameTextField = app.textFields["Last Name"]
        XCTAssertTrue(lastNameTextField.exists)
        lastNameTextField.tap()
        lastNameTextField.typeText(validLN)
        
        let emailTextField = app.textFields["USC Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let password = app.secureTextFields["Password"]
        XCTAssertTrue(password.exists)
        password.tap()
        password.typeText(validPassword)
        
        let passwordConfirm = app.secureTextFields["Confirm Password"]
        XCTAssertTrue(passwordConfirm.exists)
        passwordConfirm.tap()
        passwordConfirm.typeText(validCPassword)
        
        let returnButton = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        returnButton.tap()
        
        let ID = app.textFields["USC Student ID"]
        XCTAssertTrue(ID.exists)
        ID.tap()
        ID.typeText(validID)
        
        returnButton.tap()
        let majorTextField = app.textFields["Major"]
        XCTAssertTrue(majorTextField.exists)
        majorTextField.tap()

        
        app/*@START_MENU_TOKEN@*/.pickerWheels["Aerospace Engineering"]/*[[".pickers.pickerWheels[\"Aerospace Engineering\"]",".pickerWheels[\"Aerospace Engineering\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let createAccountStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Create Account"]/*[[".buttons[\"Create Account\"].staticTexts[\"Create Account\"]",".staticTexts[\"Create Account\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(createAccountStaticText.exists)
        createAccountStaticText.tap()
        
        XCTAssertTrue(app.buttons["Create Account"].exists)
        app.buttons["Create Account"].tap()
        
    }

}
