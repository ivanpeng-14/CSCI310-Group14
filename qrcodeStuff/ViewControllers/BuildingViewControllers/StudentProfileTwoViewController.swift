//
//  StudentProfileTwoViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 4/6/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase

class StudentProfileTwoViewController: UIViewController {
    var studentEmail: String?
    var historyArray: [String] = []
    var buildingID: String?
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func kickOutButton(_ sender: Any) {
        let db = Firestore.firestore()

        db.collection("students").document(studentEmail!).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    let studentBuilding = documentData!["currbuilding"] as? String ?? ""
                    //
                    
                    if studentBuilding == "" || self.buildingID != studentBuilding
                    {
                        let alert = UIAlertController(title: "Error", message: "Student is not checked in to this building anymore.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                            self.viewDidLoad()
                        }))
                        self.present(alert, animated: true)
                    
                    }
                    else {
                        let alert = UIAlertController(title: "Kick Out", message: "Kick this student out?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                            self.viewDidLoad()
                        }))
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                            let ref = db.collection("buildings").document(studentBuilding)
                            ref.updateData(["currentStudents" : FieldValue.arrayRemove([self.studentEmail!])])
                            let alert2 = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                            alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                                db.collection("buildings").document(studentBuilding).getDocument { (document, error) in
                                    if error == nil {
                                        let ref = db.collection("buildings").document(studentBuilding)
                                        let documentData = document!.data()
                                        let actualName = documentData!["buildingName"] as? String ?? ""
                                        //update capacity
                                        let capacity = documentData!["currentCapacity"] as? Int ?? -1
                                        let newCapacity = capacity - 1
                                        ref.updateData(["currentCapacity": newCapacity])
                                        
                                        //update students currBuilding
                                        let studentDoc = db.collection("students").document(self.studentEmail!)
                                        studentDoc.updateData(["currbuilding": ""])
                                        //update student history
                                        let studentHistory = db.collection("students").document(self.studentEmail!)
                                        studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Kicked out of \(actualName) at \(Date())"])])
                                        
                                    }
                                }
                                self.viewDidLoad()
                            }))
                            self.present(alert2, animated: true)
                        }))
                        self.present(alert, animated: true)
                        
                        
    
                        
                   }

                }

            }
        }
           
    }
        
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
   
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let ref = storage.reference()

        db.collection("students").document(studentEmail!).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    let firstname = documentData!["firstname"] as? String ?? ""
                    let lastname = documentData!["lastname"] as? String ?? ""
                    self.name.text = "\(firstname) \(lastname)"
                    let major = documentData!["major"] as? String ?? ""
                    let id = documentData!["uscid"] as? String ?? ""
                    self.id.text = "ID: \(id)"
                    self.major.text = "Major: \(major)"

                    //get profile pic
                    let pic = documentData!["photo"] as? String ?? ""
                    print(pic)
                    let imageRef = ref.child(pic)
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                      if error == nil {
                        self.profilePic.image = UIImage(data: data!)
                      } else {
                        print("picture error")
                      }
                    }
                    



                    //table view cell stuff
                    self.historyArray = documentData!["buildingHistory"] as? [String] ?? ["No History"]
                    self.tableView.reloadData()

                }
            }
            else {
                print("error")
            }
        }
    }
    

    

}

extension StudentProfileTwoViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return historyArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = historyArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! StudentHistoryTableViewCell
            cell.setHistory(history: item)
            return cell
        }
       
                
    }
