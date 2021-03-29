//
//  filterStudentsTests.swift
//  appTests
//
//  Created by Ashley Su on 3/28/21.
//

import XCTest
@testable import qrcodeStuff

class filterStudentsTests: XCTestCase {
    
    var controller: FilterStudentsTableViewController = FilterStudentsTableViewController()
    var students:[Student] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let student1 = Student(name:"ashley",major:"Computer Science",id:1234567890,building:"Tutor Hall",time:"2021-03-24 23:44:35 +0000")
        let student2 = Student(name:"jenny",major:"Computer Science",id:2222222222,building:"Pardee Tower",time:"2021-03-25 23:44:35 +0000")
        let student3 = Student(name:"claire",major:"Computer Engineering",id:1234500000,building:"Pardee Tower",time:"2021-03-24 00:44:35 +0000")
        students.append(student1)
        students.append(student2)
        students.append(student3)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        students.removeAll()
    }

    func testFilterBuildingWithStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 0 means filter by building
        let filtered = controller.filterTableView(ind: 0, text: "Pardee", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [Student(name:"jenny",major:"Computer Science",id:2222222222,building:"Pardee Tower",time:"2021-03-25 23:44:35 +0000"), Student(name:"claire",major:"Computer Engineering",id:1234500000,building:"Pardee Tower",time:"2021-03-24 00:44:35 +0000")])
    }
    
    func testFilterBuildingWithoutStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 0 means filter by building
        let filtered = controller.filterTableView(ind: 0, text: "Lyon", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [])
    }
    
    func testFilterTimeWithStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 1 means filter by time
        let filtered = controller.filterTableView(ind: 1, text: "03-25", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [Student(name:"jenny",major:"Computer Science",id:2222222222,building:"Pardee Tower",time:"2021-03-25 23:44:35 +0000")])
    }
    
    func testFilterTimeWithoutStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 0 means filter by building
        let filtered = controller.filterTableView(ind: 1, text: "03-26", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [])
    }
    
    func testFilterMajorWithStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 2 means filter by building
        let filtered = controller.filterTableView(ind: 2, text: "science", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [Student(name:"ashley",major:"Computer Science",id:1234567890,building:"Tutor Hall",time:"2021-03-24 23:44:35 +0000"), Student(name:"jenny",major:"Computer Science",id:2222222222,building:"Pardee Tower",time:"2021-03-25 23:44:35 +0000")])
    }
    
    func testFilterMajorWithoutStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 2 means filter by building
        let filtered = controller.filterTableView(ind: 2, text: "Chemical Engineering", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [])
    }
    
    func testFilterIdWithStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 3 means filter by building
        let filtered = controller.filterTableView(ind: 3, text: "12345", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [Student(name:"ashley",major:"Computer Science",id:1234567890,building:"Tutor Hall",time:"2021-03-24 23:44:35 +0000"), Student(name:"claire",major:"Computer Engineering",id:1234500000,building:"Pardee Tower",time:"2021-03-24 00:44:35 +0000")])
    }
    
    func testFilterIdWithoutStudents() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //ind: 3 means filter by building
        let filtered = controller.filterTableView(ind: 3, text: "333", initialStudents: students, students: students)
        XCTAssertEqual(filtered, [])
    }

}
