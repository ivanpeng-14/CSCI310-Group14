//
//  Student.swift
//  qrcodeStuff
//
//  Created by Ashley Su on 3/18/21.
//

import UIKit
import FirebaseFirestore

class Student: NSObject {
    weak var delegate: FilterStudentsViewController?
    
    var name:String = ""
    var major:String = ""
    var id:Int = 0
    var building:String = ""
    var time:String = ""
    
    init(name:String,major:String,id:Int,building:String,time:String) {
        self.name = name
        self.major = major
        self.id = id
        self.building = building
        self.time = time
    }
     
    override func isEqual(_ object: Any?) -> Bool {
        return (self.name == (object as? Student)?.name && self.major == (object as? Student)?.major
                    && self.id == (object as? Student)?.id && self.building == (object as? Student)?.building
                    && self.time == (object as? Student)?.time)
    }
    
    class func getStudents() -> [Student]{
        var students = [Student]()
        
        let db = Firestore.firestore()
        db.collection("students").getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let name = data["name"] as? String ?? "Anonymous"
                    if (name != "Null") {
                        let major = data["major"] as? String ?? "None"
                        let id = data["studentID"] as? Int ?? 0
                        let building = data["currBuilding"] as? String ?? "Null"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                        let time = data["lastCheckIn"] as? String ?? dateFormatter.string(from: Date())
                        let newStudent = Student(name: name, major: major, id: id, building:
                                                    building, time: time)
                        students.append(newStudent)
                    }
                }
            }
        }
        return students
    }
    
}

