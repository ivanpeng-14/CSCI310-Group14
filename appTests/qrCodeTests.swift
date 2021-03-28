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
      
        
    }
    
    func test_buildingNotAtCapacity() throws {
        let result = vc.found(curr: 3, total: 20, buildingID: "testBuilding", buildingName: "testBuilding")
        if(result != "NOT AT CAPACITY")
        {
            throw MyError.qrError(result)
        }
        
    }
    
    // correctly displays alert tests
    func test_displaysCheckInAlert() throws {
        //set up test building and student
        let db = Firestore.firestore()
    }
    
    func test_displaysCheckOutAlert() throws {
        
    }
    
    func test_displaysAlreadyCheckedInAlert() throws {
        
    }
   
    
    enum MyError: Error {
        case qrError(String)
    }
    

}
