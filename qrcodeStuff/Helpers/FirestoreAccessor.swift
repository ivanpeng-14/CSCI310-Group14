//
//  FirestoreAccessor.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import FirebaseFirestore
import FirebaseStorage
import Firebase

struct FirestoreAccessor {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let ref : StorageReference
    
    init() {
        self.ref = self.storage.reference()
    }
    
    // Firestore
    func addDocument(collection: String, _ data: [String: Any]){
        var ref: DocumentReference? = nil
        ref = db.collection(collection).addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func addStudent(first: String, last: String, email: String, uid: String, major: String, imageID: String? = nil){
        let data = ["firstname": first,
                    "lastname": last,
                    "email": email,
                    "uscid": uid,
                    "major": major,
                    "photo": imageID ?? "",
                    "deleted": false] as [String : Any]
        addDocument(collection: "students", data)
    }
    
    func addManager(first: String, last: String, email: String, uid: String, major: String, imageID: String? = nil){
        let data = ["firstname": first,
                    "lastname": last,
                    "email": email,
                    "photo": imageID ?? "",
                    "deleted": false] as [String : Any]
        addDocument(collection: "manager", data)
    }
    
    func getDocument(collection: String, _ email: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        db.collection(collection).whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let querySnapshot = querySnapshot, let doc = querySnapshot.documents.first {
                    completion((doc as DocumentSnapshot), nil)
                } else {
                    completion(nil, err)
                }
            }
    }
    
    func updateDocument(ref: DocumentReference?, key: String, val: Any) {
        if let docRef = ref {
            docRef.updateData([key : val])
        }
    }
    
    // Storage
    func storeImage(image: UIImage) -> String {
        let imageID = UUID().uuidString
        
        let imgRef = self.ref.child(imageID)
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            imgRef.putData(data)
        } else {
            return ""
        }
        
        return imageID
    }
    
    func getImage(imageID: String, completion: @escaping (UIImage?, Error?) -> Void) {
        // Create a reference to the file to download
        let imageRef = self.ref.child(imageID)

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let data = data {
            completion((UIImage(data: data)), nil)
          } else {
            completion(nil, error)
          }
        }
    }
    
    func deleteImage(imageID: String) {
        let imageRef = self.ref.child(imageID)

        // Delete the file
        imageRef.delete { error in
          if error != nil{
            print("Unable to delete provided image")
          }
        }
    }
    
}
