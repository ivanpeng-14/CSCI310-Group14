//
//  updatePasswordTests.swift
//  appTests
//
//  Created by Carlos Lao on 2021/3/28.
//

@testable import qrcodeStuff

import XCTest
import FirebaseAuth
import FirebaseFirestore

class updatePasswordTests: XCTestCase {

    let db = Firestore.firestore()
    var docRef : DocumentReference!
    var vc: qrcodeStuff.ProfileEditViewController!
    var userData : UserData?
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        self.vc = (storyboard.instantiateViewController(withIdentifier: "ProfileEditVC") as! qrcodeStuff.ProfileEditViewController)
        self.vc.loadView()
        self.vc.viewDidLoad()
        
        docRef = db.collection("students").document("testupdatepassword@usc.edu")
        
        Auth.auth().signIn(withEmail: "testupdatepassword@usc.edu", password: "123456") { (result, error) in
            
            if error != nil {
                print("Error signing in")
            }
            else {
                if let user = Auth.auth().currentUser {
                    self.vc.user = user
                    let email = user.email!
<<<<<<< HEAD
                    self.vc.userData = qrcodeStuff.UserData(email) {
=======
                    self.userData = qrcodeStuff.UserData(email) {
>>>>>>> 12214c80ee8ad2aa574732515b2ac79c6533ad9d
                        super.setUp()
                    }
                }
            }
        }
    }

    override func tearDownWithError() throws {
        Auth.auth().currentUser?.updatePassword(to: "123456") { (error) in
            self.docRef.updateData(["password": "123456"])
        }
        
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPasswordUpdate1() throws {
        vc.oldPassword.text = ""
        vc.newPassword.text = ""
        vc.confirmNewPassword.text = ""
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, 0)
        XCTAssertEqual(newPassword, "123456")
    }

    func testPasswordUpdate2() throws {
        let num = Int.random(in: 0...2)
        
        vc.oldPassword.text = num == 0 ? "" : "123456"
        vc.newPassword.text = num == 1 ? "" : "654321"
        vc.confirmNewPassword.text = num == 2 ? "" : "654321"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, 0)
        XCTAssertEqual(newPassword, "123456")
    }
    
    func testPasswordUpdate3() throws {
        vc.oldPassword.text = "123456"
        vc.newPassword.text = "123456"
        vc.confirmNewPassword.text = "123456"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 30, handler: nil)
        
        XCTAssertEqual(err_index, 4)
        XCTAssertEqual(newPassword, "123456")
    }
    
    func testPasswordUpdate4() throws {
        vc.oldPassword.text = "1234567"
        vc.newPassword.text = "654321"
        vc.confirmNewPassword.text = "654321"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, 1)
        XCTAssertEqual(newPassword, "123456")
    }
    
    func testPasswordUpdate5() throws {
        vc.oldPassword.text = "123456"
        vc.newPassword.text = "123"
        vc.confirmNewPassword.text = "123"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, 3)
        XCTAssertEqual(newPassword, "123456")
    }
    
    func testPasswordUpdate6() throws {
        vc.oldPassword.text = "123456"
        vc.newPassword.text = "123"
        vc.confirmNewPassword.text = "246"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, 2)
        XCTAssertEqual(newPassword, "123456")
    }
    
    func testPasswordUpdate7() throws {
        vc.oldPassword.text = "123456"
        vc.newPassword.text = "654321"
        vc.confirmNewPassword.text = "567890"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, 2)
        XCTAssertEqual(newPassword, "123456")
    }
    
    func testPasswordUpdate8() throws {
        vc.oldPassword.text = "123456"
        vc.newPassword.text = "654321"
        vc.confirmNewPassword.text = "654321"
        
        var newPassword : String!
        
        let expectation = self.expectation(description: "Document Info Acquired")
        
        let err_index = vc.updatePasswordHelper()
        
        self.docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                newPassword = (data["password"] as! String)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(err_index, -1)
        XCTAssertEqual(newPassword, "654321")
    }

}
