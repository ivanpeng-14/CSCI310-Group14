//
//  BuildingXXXViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class StudentVisitHistoryViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numStudentsLabel: UITextField!
    
    @IBAction func checkoutButton(_ sender: Any) {
        let userID = userEmail
        print(userID)
        let db = Firestore.firestore()
        db.collection("students").document(userID).getDocument { (document, error) in
            if error == nil {
                let studentBuildingName = document!.data()!["currbuilding"] as? String ?? ""
            
                if (studentBuildingName == "")
                {
                    let alert = UIAlertController(title: "Check Out", message: "You are not checked to any building.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                        self.viewDidLoad()
                    }))
                    self.present(alert, animated: true)
                }
                else
                {
                    let alert = UIAlertController(title: "Check Out", message: "Check out of building?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                        self.viewDidLoad()
                    }))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        let ref = db.collection("buildings").document(studentBuildingName)
                        
                        ref.updateData(["currentStudents" : FieldValue.arrayRemove([userID])])
                        sleep(3)
                        
                        db.collection("buildings").document(studentBuildingName).getDocument { (document, error) in
                            if error == nil {
                                let documentData = document!.data()
                                let actualName = documentData!["buildingName"] as? String ?? ""
                                //update capacity
                                let capacity = documentData!["currentCapacity"] as? Int ?? -1
                                let newCapacity = capacity - 1
                                ref.updateData(["currentCapacity": newCapacity])
                                
            
                        
                                //update students currBuilding
                                let studentDoc = db.collection("students").document(userID)
                                studentDoc.updateData(["currbuilding": ""])
                                //update student history
                                let studentHistory = db.collection("students").document(userID)
                                studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked out of \(actualName) at \(Date())"])])
                                
                            }
                        }
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
        
        
       
        
        
    }
    private var service: BuildingService?
    private var allbuildings = [appBuilding]() {
        didSet {
            DispatchQueue.main.async {
                self.buildings = self.allbuildings
            }
        }
    }
    
    var buildings = [appBuilding]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    let user = Auth.auth().currentUser
    var userEmail = ""
    var studentVisitHistory = [[String]]()
    var tempBuildingHistory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
//        displayUserData()
    }
    
    func loadData() {
//        let db = Firestore.firestore()
        service = BuildingService()
              service?.get(collectionID: "buildings") { buildings in
             self.allbuildings = buildings
         }
        setUserEmail()
        setBuildingData()
    }
    
    func setUserEmail() {
        if let emailWrapped = user?.email {
            userEmail = emailWrapped
            print(userEmail)
            
        }
    }
    
    func setBuildingData() {
        let db = Firestore.firestore()
//        var buildingHistory: [String] = []
        
        // Grabbing buildingHistory data
        db.collection("students").document(userEmail).addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
//              print("Current data: \(data)")
            self.tempBuildingHistory = data["buildingHistory"] as? [String] ?? []
            self.tempBuildingHistory.reverse()
            print("buildingHistory: \(self.tempBuildingHistory)")
            
        }
        
        

    }
    
    @IBAction func checkInTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let studentHistory = db.collection("students").document(userEmail)
        studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked into SGM106 at \(Date())"])])
    }
    
}
extension StudentVisitHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempBuildingHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var buildingName = ""
        var buildingTime = ""
        var checkIn = false
        
        if tempBuildingHistory[indexPath.row].contains("into") { // check in
            
            let list = tempBuildingHistory[indexPath.row].split(separator: " ")
            print(list)
            buildingName = String(list[2] + " " + list[3] + " " + list[4])
            buildingTime = String(list[6] + ", " + list[7])
            checkIn = true
        }
        else { // check out
            
            let list = tempBuildingHistory[indexPath.row].split(separator: " ")
            print(list)
            buildingName = String(list[3] + " " + list[4] + " " + list[5])
            buildingTime = String(list[7] + ", " + list[8])
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as! BuildingManageTableViewCell
        cell.setBuildingViewFeed(buildingName: buildingName, lastCheckInTime: buildingTime, checkIn: checkIn)
        return cell
    }
    
}

