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
    var lastName:String = ""
    var email:String = ""
    var major:String = ""
    var id:String = ""
    var building:String = ""
    var time:String = ""
    var deleted:Bool = false
    
    init(name:String,lastName:String,email:String,major:String,id:String,building:String,time:String,deleted:Bool) {
        self.name = name
        self.lastName = lastName
        self.email = email
        self.major = major
        self.id = id
        self.building = building
        self.time = time
        self.deleted = deleted
    }
     
    override func isEqual(_ object: Any?) -> Bool {
        return (self.name == (object as? Student)?.name && self.major == (object as? Student)?.major
                    && self.id == (object as? Student)?.id && self.building == (object as? Student)?.building
                    && self.time == (object as? Student)?.time)
    }
}

