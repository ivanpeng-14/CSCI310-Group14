//
//  deleteAccountTests.swift
//  appTests
//
//  Created by Carlos Lao on 2021/3/28.
//

@testable import qrcodeStuff

import XCTest
import FirebaseAuth
import FirebaseFirestore

class deleteAccountTests: XCTestCase {
    
    let db = Firestore.firestore()
    var docRef : DocumentReference!
    var vc: qrcodeStuff.DeleteAccountViewController!
    var initialBuilding = "6zq8CFw2xjKaEPbfvkIF"
    
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        self.vc = (storyboard.instantiateViewController(withIdentifier: "DeleteAccountVC") as! qrcodeStuff.DeleteAccountViewController)
        self.vc.loadView()
        self.vc.viewDidLoad()
        
        docRef = db.collection("students").document("crlao@usc.edu")
        
        let expectation = self.expectation(description: "Loaded User Data")
        
        var userData = qrcodeStuff.UserData("crlao@usc.edu") {
            expectation.fulfill()
        }
        
        Auth.auth().signIn(withEmail: "crlao@usc.edu", password: "123456") { (result, error) in
            
            if error != nil {
                print("Error signing in")
            }
            else {
                self.vc.user = Auth.auth().currentUser
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        self.vc.userData = userData
        
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDelete1() throws {
        let deleted = self.passwordHelper("1234567", "12345678", "123456")
        let gotCheckedOut = self.vc.willCheckOut(self.initialBuilding) && deleted
        
        XCTAssertFalse(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete2() throws {
        let deleted = self.passwordHelper("1234567", "12345678", "123456")
        let gotCheckedOut = self.vc.willCheckOut("") && deleted
        
        XCTAssertFalse(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete3() throws {
        let deleted = self.passwordHelper("1234567", "1234567", "123456")
        let gotCheckedOut = self.vc.willCheckOut(self.initialBuilding) && deleted
        
        XCTAssertFalse(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete4() throws {
        let deleted = self.passwordHelper("1234567", "1234567", "123456")
        let gotCheckedOut = self.vc.willCheckOut("") && deleted
        
        XCTAssertFalse(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete5() throws {
        let deleted = self.passwordHelper("123456", "1234567", "123456")
        let gotCheckedOut = self.vc.willCheckOut(self.initialBuilding) && deleted
        
        XCTAssertFalse(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete6() throws {
        let deleted = self.passwordHelper("123456", "1234567", "123456")
        let gotCheckedOut = self.vc.willCheckOut("") && deleted
        
        XCTAssertFalse(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete7() throws {
        let deleted = self.passwordHelper("123456", "123456", "123456")
        let gotCheckedOut = self.vc.willCheckOut(self.initialBuilding) && deleted
        
        XCTAssertTrue(deleted)
        XCTAssertTrue(gotCheckedOut)
    }
    
    func testDelete8() throws {
        let deleted = self.passwordHelper("123456", "123456", "123456")
        let gotCheckedOut = self.vc.willCheckOut("") && deleted
        
        XCTAssertTrue(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func testDelete9() throws {
        self.docRef = db.collection("manager").document("email@usc.edu")
        vc.userData = UserData("email@usc.edu")
        
        let expectation = self.expectation(description: "Data Acquired")
        
        var deleted = false
        var gotCheckedOut = true
        
        Auth.auth().signIn(withEmail: "email@usc.edu", password: "password") { (result, error) in
            
            if error != nil {
                print("An error occured while logging in")
            }
            else {
                self.vc.user = Auth.auth().currentUser
                self.docRef?.getDocument() { doc, err in
                    if (doc?.data()) != nil {
                        deleted = self.passwordHelper("password", "password", "password")
                        gotCheckedOut = self.vc.willCheckOut(self.initialBuilding) && deleted
                        expectation.fulfill()
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(deleted)
        XCTAssertFalse(gotCheckedOut)
    }
    
    func passwordHelper(_ password: String, _ confirmation: String, _ correct: String) -> Bool{
        self.vc.password.text = password
        self.vc.confirmPassword.text = confirmation
        
        let passwordCorrect = password == correct
        let passwordsMatch = password == confirmation
        
        return vc.attemptDelete(passwordCorrect, passwordsMatch)
    }
}
