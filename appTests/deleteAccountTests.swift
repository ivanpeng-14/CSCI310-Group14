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
        
        self.vc.userData = qrcodeStuff.UserData("crlao@usc.edu")
        
        Auth.auth().signIn(withEmail: "crlao@usc.edu", password: "123456") { (result, error) in
            
            if error != nil {
                print("Error signing in")
            }
            else {
                self.vc.user = Auth.auth().currentUser
            }
        }
    }

    override func tearDownWithError() throws {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDelete1() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: initialBuilding)
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("1234567", "12345678", correct_password)
 
                XCTAssertFalse(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, self.initialBuilding)
            }
        }
    }
    
    func testDelete2() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: "")
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("1234567", "12345678", correct_password)
                
                XCTAssertFalse(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, "")
            }
        }
    }
    
    func testDelete3() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: initialBuilding)
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("1234567", "1234567", correct_password)
                
                XCTAssertFalse(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, self.initialBuilding)
            }
        }
    }
    
    func testDelete4() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: "")
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("1234567", "1234567", correct_password)
                
                XCTAssertFalse(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, "")
            }
        }
    }
    
    func testDelete5() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: initialBuilding)
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("123456", "1234567", correct_password)
                
                XCTAssertFalse(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, self.initialBuilding)
            }
        }
    }
    
    func testDelete6() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: "")
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("123456", "1234567", correct_password)
                
                XCTAssertFalse(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, "")
            }
        }
    }
    
    func testDelete7() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: initialBuilding)
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("123456", "123456", correct_password)
                
                XCTAssertTrue(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, "")
            }
        }
    }
    
    func testDelete8() throws {
        self.vc.userData?.updateData(key: "currbuilding", val: "")
        
        docRef?.getDocument() { doc, err in
            if let data = doc?.data() {
                let correct_password = (data["password"] as! String)
                self.passwordHelper("123456", "123456", correct_password)
                
                XCTAssertTrue(data["deleted"] as! Bool)
                XCTAssertEqual(data["currbuilding"] as! String, "")
            }
        }
    }
    
    func testDelete9() throws {
        self.docRef = db.collection("manager").document("email@usc.edu")
        vc.userData = UserData("email@usc.edu")
        
        Auth.auth().signIn(withEmail: "email@usc.edu", password: "password") { (result, error) in
            
            if error != nil {
                print("An error occured while logging in")
            }
            else {
                self.vc.user = Auth.auth().currentUser
                self.docRef?.getDocument() { doc, err in
                    if let data = doc?.data() {
                        let correct_password = (data["password"] as! String)
                        self.passwordHelper("123456", "123456", correct_password)
                        
                        XCTAssertTrue(data["deleted"] as! Bool)
                        XCTAssertEqual(data["currbuilding"] as! String, "")
                    }
                }
            }
        }
    }
    
    func passwordHelper(_ password: String, _ confirmation: String, _ correct: String){
        let passwordCorrect = password == correct
        let passwordsMatch = password == confirmation
        
        _ = vc.attemptDelete(passwordCorrect, passwordsMatch)
    }
}
