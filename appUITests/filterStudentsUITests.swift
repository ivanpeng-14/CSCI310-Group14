//
//  appUITests.swift
//  appUITests
//
//  Created by Ashley Su on 3/28/21.
//

import XCTest

class filterStudentsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        self.continueAfterFailure = false
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFilterByBuildingSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        // UI tests must launch the application that they test.
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("email@usc.edu")
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password")
     
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        
        app.tabBars["Tab Bar"].buttons["My Buildings"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Search Students"]/*[[".buttons[\"Search Students\"].staticTexts[\"Search Students\"]",".staticTexts[\"Search Students\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let searchField = app.tables.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("Pardee")
        let Pardee1_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Jenny Hu")/*[[".cells.containing(.staticText, identifier:\"12345\")",".cells.containing(.staticText, identifier:\"2021-03-25 01:07:34 +0000\")",".cells.containing(.staticText, identifier:\"(Astronautical Engineering)\")",".cells.containing(.staticText, identifier:\"Jenny Hu\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        let Pardee2_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"new student")/*[[".cells.containing(.staticText, identifier:\"1231231231\")",".cells.containing(.staticText, identifier:\"2021-03-24 05:52:31 +0000\")",".cells.containing(.staticText, identifier:\"(Chemical Engineering)\")",".cells.containing(.staticText, identifier:\"new student\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        let notPardee_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Carlos Lao")/*[[".cells.containing(.staticText, identifier:\"3156617048\")",".cells.containing(.staticText, identifier:\"2021-03-24 23:44:35 +0000\")",".cells.containing(.staticText, identifier:\"Lyon Center (LRC)\")",".cells.containing(.staticText, identifier:\"(Computer Science)\")",".cells.containing(.staticText, identifier:\"Carlos Lao\")"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        XCTAssertTrue(Pardee1_cell.exists)
        XCTAssertTrue(Pardee2_cell.exists)
        XCTAssertFalse(notPardee_cell.exists)
    }
    
    func testFilterByTimeSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        // UI tests must launch the application that they test.
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("email@usc.edu")
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password")
     
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        
        app.tabBars["Tab Bar"].buttons["My Buildings"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Search Students"]/*[[".buttons[\"Search Students\"].staticTexts[\"Search Students\"]",".staticTexts[\"Search Students\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.tables.buttons["Check In Time"].tap()
        let searchField = app.tables.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("03-24")
        let cell1 = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Carlos Lao")/*[[".cells.containing(.staticText, identifier:\"3156617048\")",".cells.containing(.staticText, identifier:\"2021-03-24 23:44:35 +0000\")",".cells.containing(.staticText, identifier:\"Lyon Center (LRC)\")",".cells.containing(.staticText, identifier:\"(Computer Science)\")",".cells.containing(.staticText, identifier:\"Carlos Lao\")"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        let cell2 = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"new student")/*[[".cells.containing(.staticText, identifier:\"1231231231\")",".cells.containing(.staticText, identifier:\"2021-03-24 05:52:31 +0000\")",".cells.containing(.staticText, identifier:\"(Chemical Engineering)\")",".cells.containing(.staticText, identifier:\"new student\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        let cell3 = app.tables.cells.containing(.staticText, identifier:"Jenny Hu").element
        XCTAssertTrue(cell1.exists)
        XCTAssertTrue(cell2.exists)
        XCTAssertFalse(cell3.exists)
    }
    
    func testFilterByMajorSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        // UI tests must launch the application that they test.
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("email@usc.edu")
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password")
     
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        
        app.tabBars["Tab Bar"].buttons["My Buildings"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Search Students"]/*[[".buttons[\"Search Students\"].staticTexts[\"Search Students\"]",".staticTexts[\"Search Students\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.tables.buttons["Major"].tap()
        let searchField = app.tables.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("Computer Science")
        let cs_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Carlos Lao")/*[[".cells.containing(.staticText, identifier:\"3156617048\")",".cells.containing(.staticText, identifier:\"2021-03-24 23:44:35 +0000\")",".cells.containing(.staticText, identifier:\"Lyon Center (LRC)\")",".cells.containing(.staticText, identifier:\"(Computer Science)\")",".cells.containing(.staticText, identifier:\"Carlos Lao\")"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        let nonCs_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"new student")/*[[".cells.containing(.staticText, identifier:\"1231231231\")",".cells.containing(.staticText, identifier:\"2021-03-24 05:52:31 +0000\")",".cells.containing(.staticText, identifier:\"(Chemical Engineering)\")",".cells.containing(.staticText, identifier:\"new student\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        XCTAssertTrue(cs_cell.exists)
        XCTAssertFalse(nonCs_cell.exists)
    }
    
    func testFilterByIdSuccess() throws {
        let app = XCUIApplication()
        app.launch()
        
        // UI tests must launch the application that they test.
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("email@usc.edu")
        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("password")
     
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue"]/*[[".buttons[\"Continue\"].staticTexts[\"Continue\"]",".staticTexts[\"Continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Continue to Profile"]/*[[".buttons[\"Continue to Profile\"].staticTexts[\"Continue to Profile\"]",".staticTexts[\"Continue to Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        
        app.tabBars["Tab Bar"].buttons["My Buildings"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Search Students"]/*[[".buttons[\"Search Students\"].staticTexts[\"Search Students\"]",".staticTexts[\"Search Students\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.tables.buttons["USC ID"].tap()
        let searchField = app.tables.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("1231231231")
        
        let id_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"new student")/*[[".cells.containing(.staticText, identifier:\"1231231231\")",".cells.containing(.staticText, identifier:\"2021-03-24 05:52:31 +0000\")",".cells.containing(.staticText, identifier:\"(Chemical Engineering)\")",".cells.containing(.staticText, identifier:\"new student\")"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        let nonId_cell = app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Carlos Lao")/*[[".cells.containing(.staticText, identifier:\"3156617048\")",".cells.containing(.staticText, identifier:\"2021-03-24 23:44:35 +0000\")",".cells.containing(.staticText, identifier:\"Lyon Center (LRC)\")",".cells.containing(.staticText, identifier:\"(Computer Science)\")",".cells.containing(.staticText, identifier:\"Carlos Lao\")"],[[[-1,4],[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.element
        XCTAssertTrue(id_cell.exists)
        XCTAssertFalse(nonId_cell.exists)
    }
    
    

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }

}
