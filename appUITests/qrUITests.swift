//
//  qrUITests.swift
//  appUITests
//
//  Created by Jenny Hu on 3/28/21.
//

import XCTest

class qrUITests: XCTestCase {

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

    func test_tutorHallQRCode() {
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
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()


        app/*@START_MENU_TOKEN@*/.staticTexts["Paste"]/*[[".menus",".menuItems[\"Paste\"].staticTexts[\"Paste\"]",".staticTexts[\"Paste\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

        passwordSecureTextField.setText(text: password, application: app)

        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        app.tabBars["Tab Bar"].buttons["My Buildings"].tap()
        
        app.tables.cells.containing(.staticText, identifier:"Tutor Hall (RTH)").staticTexts["Get Code"].tap()
        app.alerts["Building Info"].scrollViews.otherElements.buttons["Get QR Code"].tap()
        
        sleep(30)

    }
    
    //check in/out alert tests
    
    func test_checkIn() throws { //qruser1, testCheckIn, EJysxWzWo3bm934M0ZIv
        let studentUser = "qruser1@usc.edu"
        let app = XCUIApplication()
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(studentUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()

        app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        sKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
    
        
        app.buttons["Continue"].tap()
        app.buttons["Continue to Profile"].tap()
        app.tabBars["Tab Bar"].buttons["Scanner"].tap()
        sleep(10)
        
        XCTAssertTrue(app.alerts["Check In"].exists)
        XCTAssertFalse(app.alerts["Check Out"].exists)
        XCTAssertFalse(app.alerts["Error"].exists)
        
        
    }
    func test_checkOut() throws { //qruser2, testCheckOut, lEHqh3psSwR0S7vkDFef
        let studentUser = "qruser2@usc.edu"
        let app = XCUIApplication()
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(studentUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()

        app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        sKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Continue"].tap()
        app.buttons["Continue to Profile"].tap()
        app.tabBars["Tab Bar"].buttons["Scanner"].tap()
        sleep(10)
        
        XCTAssertTrue(app.alerts["Check Out"].exists)
        XCTAssertFalse(app.alerts["Check In"].exists)
        XCTAssertFalse(app.alerts["Error"].exists)
    }
    func test_checkOutB4CheckIn() throws { //qruser3, testCheckOutB4CheckIn, IBwpa7536UXg9QSnj5cP
        let studentUser = "qruser3@usc.edu"
        let app = XCUIApplication()
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(studentUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()

        app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        sKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Continue"].tap()
        app.buttons["Continue to Profile"].tap()
        app.tabBars["Tab Bar"].buttons["Scanner"].tap()
        sleep(10)
        
        XCTAssertTrue(app.alerts["Error"].exists)
        XCTAssertFalse(app.alerts["Check In"].exists)
        XCTAssertFalse(app.alerts["Check Out"].exists)
    }
    
    func test_atCapacity() throws {
        let studentUser = "qruser1@usc.edu"
        let app = XCUIApplication()
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(studentUser)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()

        app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        sKey.tap()
        app/*@START_MENU_TOKEN@*/.keys["w"]/*[[".keyboards.keys[\"w\"]",".keys[\"w\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
    
        
        app.buttons["Continue"].tap()
        app.buttons["Continue to Profile"].tap()
        app.tabBars["Tab Bar"].buttons["Scanner"].tap()
        sleep(10)
        
        XCTAssertTrue(app.alerts["Building at Capacity"].exists)
        XCTAssertFalse(app.alerts["Check Out"].exists)
        XCTAssertFalse(app.alerts["Error"].exists)
        XCTAssertFalse(app.alerts["Check In"].exists)
    }

}

extension XCUIElement {
    // The following is a workaround for inputting text in the
    //simulator when the keyboard is hidden
    func setText(text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
    }
}


