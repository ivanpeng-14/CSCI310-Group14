//
//  qrCodeTests.swift
//
//
//  Created by Jenny Hu on 3/27/21.
//

@testable import qrcodeStuff

import XCTest
import FirebaseFirestore

class qrCodeTests: XCTestCase {
    
var vc = ScannerViewController()

    
    override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
         
    }

    override func tearDown()  {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_buildingAtCapacity() throws {
        let result: String = vc.found(curr: 20, total: 20, buildingID: "testBuilding", buildingName: "testBuilding")
        if(result != "AT CAPACITY")
        {
            throw MyError.qrError(result)
        }
        let result2: String = vc.found(curr: 30, total: 20, buildingID: "testBuilding", buildingName: "testBuilding")
        if(result2 != "AT CAPACITY")
        {
            throw MyError.qrError(result)
        }
        
    }
    
    
    // correctly displays alert tests
    func test_displaysAlreadyCheckedInAlert() throws {
        let result = vc.displayAlert(studentBuilding: "currentBuilding", curr: 3, total: 20, buildingID: "currentBuilding", buildingName: "currentBuilding")
        if(result != "Already checked in, can check out now.")
        {
            throw MyError.qrError("Error")
        }
        let result2 = vc.displayAlert(studentBuilding: "", curr: 3, total: 20, buildingID: "newBuilding", buildingName: "newBuilding")
        if(result2 == "Already checked in, can check out now.")
        {
            throw MyError.qrError("Error")
        }
        let result3 = vc.displayAlert(studentBuilding: "currentBuilding", curr: 3, total: 20, buildingID: "someOtherBuilding", buildingName: "someOtherBuilding")
        if(result3 == "Already checked in, can check out now.")
        {
            throw MyError.qrError("Error")
        }
    }
    
    
    func test_displaysCheckInAlert() throws {
        let result = vc.displayAlert(studentBuilding: "", curr: 3, total: 20, buildingID: "newBuilding", buildingName: "newBuilding")
        if(result != "Not checked in anywhere, can check in now")
        {
            throw MyError.qrError(result)
        }
        let result2 = vc.displayAlert(studentBuilding: "currBuilding", curr: 3, total: 20, buildingID: "currBuilding", buildingName: "currBuilding")
        if(result2 == "Not checked in anywhere, can check in now")
        {
            throw MyError.qrError("Error")
        }
        let result3 = vc.displayAlert(studentBuilding: "currentBuilding", curr: 3, total: 20, buildingID: "someOtherBuilding", buildingName: "someOtherBuilding")
        if(result3 == "Not checked in anywhere, can check in now")
        {
            throw MyError.qrError("Error")
        }
        
        
    }
    
    func test_displaysCheckOutAlert() throws {
        let result = vc.displayAlert(studentBuilding: "currentBuilding", curr: 3, total: 20, buildingID: "someOtherBuilding", buildingName: "someOtherBuilding")
        if(result != "Needs to check out first.")
        {
            throw MyError.qrError(result)
        }
        let result2 = vc.displayAlert(studentBuilding: "", curr: 3, total: 20, buildingID: "newBuilding", buildingName: "newBuilding")
        if(result2 == "Needs to check out first.")
        {
            throw MyError.qrError("Error")
        }
        let result3 = vc.displayAlert(studentBuilding: "currentBuilding", curr: 3, total: 20, buildingID: "currentBuilding", buildingName: "currentBuilding")
        if(result3 == "Needs to check out first.")
        {
            throw MyError.qrError("Error")
        }
    }
    
    
    enum MyError: Error {
        case qrError(String)
    }
    

}
