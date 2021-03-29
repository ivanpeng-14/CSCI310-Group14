//
//  addBuildingUITests.swift
//  appUITests
//
//  Created by Serena He on 3/28/21.
//

import XCTest

class addBuildingUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func genRanStr() -> String{
        let letters = "ABCDEFGHIJKLMNOP";
          return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    func test_emptyTextFields() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let managerUser = "manager1@usc.edu"
        let password = "password"


        let app = XCUIApplication()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(managerUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Add Building"].tap()
        
        let addBuildingButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let assertion = app.staticTexts["Invalid building name"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assertion, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        
        
        
    }
    
    func test_validBuildingNameEmptyCapacity() throws {
        let managerUser = "manager1@usc.edu"
        let password = "password"
        let str = genRanStr();

        let app = XCUIApplication()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(managerUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Add Building"].tap()
        
        let addBuildingButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText(str)
        textField.setText(text: str, application: app)
        
        let textField2 = element.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let assertion = app.staticTexts["Invalid capacity"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assertion, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_validBuildingNameNonnumberCapacity() throws {
        let managerUser = "manager1@usc.edu"
        let password = "password"
        let str = genRanStr();

        let app = XCUIApplication()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(managerUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Add Building"].tap()
        
        let addBuildingButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText(str)
        textField.setText(text: str, application: app)
        
        let textField2 = element.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField.setText(text: str, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let assertion = app.staticTexts["Invalid capacity"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assertion, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_validBuildingNameNonpositiveCapacity() throws {
        let managerUser = "manager1@usc.edu"
        let password = "password"
        let str = genRanStr();

        let app = XCUIApplication()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(managerUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Add Building"].tap()
        
        let addBuildingButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText(str)
        textField.setText(text: str, application: app)
        
        let textField2 = element.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        textField.setText(text: "0", application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let assertion = app.staticTexts["Invalid capacity"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assertion, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_validBuildingNameValidCapacity() throws {
        let managerUser = "manager1@usc.edu"
        let password = "password"
        let str = genRanStr();

        let app = XCUIApplication()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(managerUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Add Building"].tap()
        
        let addBuildingButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText(str)
        textField.setText(text: str, application: app)
        
        let textField2 = element.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app.staticTexts["Add"].tap()
        
        let assertion = app.staticTexts["Building successfully added!"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assertion, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_validBuildingNameValidCapacityButDuplicate() throws {
        let managerUser = "manager1@usc.edu"
        let password = "password"
        let str = genRanStr();

        let app = XCUIApplication()
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(managerUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(password)
        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.tabBars["Tab Bar"].buttons["Add Building"].tap()
        
        let addBuildingButton = app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        let textField = element.children(matching: .textField).element(boundBy: 0)
        textField.tap()
        textField.typeText(str)
        textField.setText(text: str, application: app)
        
        let textField2 = element.children(matching: .textField).element(boundBy: 1)
        textField2.tap()
        app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: addBuildingButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        textField.tap()
        textField.typeText(str)
        textField.setText(text: str, application: app)
        
        textField2.tap()
        app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let assertion = app.staticTexts["Building already exists"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: assertion, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


}

