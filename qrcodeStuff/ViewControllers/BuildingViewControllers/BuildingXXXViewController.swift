//
//  BuildingXXXViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit
import FirebaseFirestore

class BuildingXXXViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numStudentsLabel: UITextField!
    @IBOutlet weak var buildingNameLabel: UILabel!
    
    var buildingName: String?
    var studentsArray: [String] = []
    var IDArray: [String] = []
    var emailArray: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

        buildingNameLabel.text = buildingName!
    
        let db = Firestore.firestore()
        
        db.collection("buildings").whereField("buildingName", isEqualTo: self.buildingName).getDocuments { (querySnapshot, error) in
            if error == nil {
                for document in querySnapshot!.documents {
                    let buildingID = document.documentID
                    db.collection("buildings").document(buildingID).getDocument { (document, error) in
                        if error == nil {
                            //check if document exists
                            if document != nil && document!.exists {
                                let documentData = document!.data()
                                //fix label
                                let currNum = documentData!["currentCapacity"] as? Int ?? -1
                                //let totalNum = documentData!["totalCapacity"] as? Int ?? -1
                                self.numStudentsLabel.text = "There are currently \(currNum) student(s) in this building"
                                
                                let tempArray = documentData!["currentStudents"] as? [String] ?? ["Building is empty"]
                                for item in tempArray
                                {
                                    print(item)
                                    db.collection("students").document(item).getDocument { (document, error) in
                                        let documentData = document!.data()
                                        let firstName = documentData!["firstname"] as? String ?? ""
                                        let lastName = documentData!["lastname"] as? String ?? ""
                                        let name = "\(firstName) \(lastName)"
                                        print(name)
                                        self.studentsArray.append((name))
                                        let id = documentData!["uscid"] as? String ?? ""
                                        self.IDArray.append(String(id))
                                        let email = documentData!["email"] as? String ?? ""
                                        self.emailArray.append(email)
                                        self.tableView.reloadData()
                                    }
                                }
                              
                               
                            }
                         
                        }
                        else {
                            print("Building does not exist")
                        }
                        
                    }
                }
            }
        }
        
        
    }
  

}
extension BuildingXXXViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return studentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentName = studentsArray[indexPath.row]
        let studentID = IDArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as! BuildingXXXTableViewCell
        cell.setStudent(studentName: studentName, studentID: studentID)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "View Student Profile?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "studentSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StudentProfileTwoViewController {
            // destination.modalPresentationStyle = .fullScreen
            let index = tableView.indexPathForSelectedRow?.row
            destination.studentEmail = emailArray[index!]
        }
        
    }
    
    
}
