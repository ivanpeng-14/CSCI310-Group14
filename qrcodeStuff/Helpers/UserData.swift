//
//  UserData.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/22.
//

import Foundation
import FirebaseFirestore

class UserData {
    let db = FirestoreAccessor()
    
    var student : Bool?
    var data : [String : Any]?
    
    var ref : DocumentReference?
    
    init(_ email: String, completion: @escaping () -> Void = {}) {
        db.getDocument(collection: "students", email) { doc, err in
            if err != nil{
                self.db.getDocument(collection: "manager", email) { doc, err in
                    if let doc = doc {
                        self.student = false
                        self.data = doc.data()!
                        self.ref = doc.reference
                        completion()
                    }
                }
            }
            if let doc = doc {
                self.student = true
                self.data = doc.data()!
                self.ref = doc.reference
                completion()
            }
        }
    }
    
    func isStudent() -> Bool {
        return self.student ?? false
    }
    
    func getInfo(_ key: String) -> Any? {
        return data?[key]
    }
    
    func getPhoto(completion: @escaping (UIImage?, Error?) -> Void) {
        if let photoID = data?["photo"] as? String, photoID != ""{
            db.getImage(imageID: photoID) { img, err in
                if let img = img {
                    completion(img, nil)
                } else {
                    completion(nil, err)
                }
            }
        } else{
            completion(UIImage(systemName: "person.fill"), nil)
        }
    }
    
    func updateData(key: String, val: Any) {
        self.data?[key] = val
        db.updateDocument(ref: ref, key: key, val: val)
    }
    
    func updatePhoto(image: UIImage) {
        if let photoID = data?["photo"] as? String, photoID != ""{
            db.deleteImage(imageID: photoID)
        }
        self.updateData(key: "photo", val: db.storeImage(image: image))
    }
}
