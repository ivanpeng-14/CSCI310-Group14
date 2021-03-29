//
//  buildingsTests.swift
//  appTests
//
//  Created by Claire Jutabha on 3/28/21.
//
@testable import qrcodeStuff

import XCTest
import FirebaseFirestore

class buildingsTests: XCTestCase {

    var vc: qrcodeStuff.BuildingsManageViewController!
    var allbuildings = [appBuilding]()
    
    private func setUpViewControllers() {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            
        self.vc = (storyboard.instantiateViewController(withIdentifier: "BuildingsIManageVC") as! qrcodeStuff.BuildingsManageViewController) //
            self.vc.loadView()
            self.vc.viewDidLoad()
            allbuildings = vc.allbuildings
        }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        self.setUpViewControllers()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        vc = nil
        super.tearDown()
    }

    //check that the view shows up --> ran into human error with inconsistent naming of the class
    func test_BuildingViewExist() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertNotNil(self.vc, "Main VC is nil")
    }

    //database call returns a non-empty array
    func test_BuildingData() throws {
        XCTAssertNotNil(allbuildings)
    }

}
