//
//  Login_Registration_UITests.swift
//  Login_Registration_UITests
//
//  Created by Ivan Peng on 3/28/21.
//

import XCTest

class Login_Registration_UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInvalidLogin_MissingFieldsErrorLabelShow() {
        
        let emptyEmail = ""
        let emptyPassword = ""
        
        let app = XCUIApplication()
        app.launch()
        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(emptyEmail)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(emptyPassword)
        
        let continueStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        continueStaticText.tap()
        let errorLabel = app.staticTexts["Please fill in all fields."]
        XCTAssertTrue(errorLabel.exists)
        
    }
    
    func testValidLoginSuccess() {
        
        let validEmail = "newstudent@usc.edu"
        let validPassword = "newstudent12345"
        
        let app = XCUIApplication()
        app.launchArguments = ["NoAnimations"]
        app.launch()

        
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(validEmail)
        
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(validPassword)

        
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        let continueToProfile = app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: continueToProfile, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
                
                    
    }
}