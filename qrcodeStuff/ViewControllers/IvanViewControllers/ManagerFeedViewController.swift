//
//  BuildingXXXViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class ManagerFeedViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numStudentsLabel: UITextField!
    
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
    var managerVisitHistory = [[String]]()
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
        db.collection("manager").document(userEmail).addSnapshotListener { documentSnapshot, error in
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
    
    func parseBuilding(buildingHistoryList: [String]) {
        
    }
    
    @IBAction func managerCheckIn(_ sender: Any) {
        
        let db = Firestore.firestore()
        let managerHistory = db.collection("manager").document(userEmail)
        managerHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked out of GFS114 at \(Date())"])])
    }
    
    
    
}
extension ManagerFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempBuildingHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var buildingName = ""
        var buildingTime = ""
        var checkIn = false
        
        if tempBuildingHistory[indexPath.row].count == 7 { // check in
            
            let list = tempBuildingHistory[indexPath.row].split(separator: " ")
            
            buildingName = String(list[2])
            buildingTime = String(list[3] + ", " + list[4])
            checkIn = true
        }
        else { // check out
            
            let list = tempBuildingHistory[indexPath.row].split(separator: " ")
            
            buildingName = String(list[3])
            buildingTime = String(list[5] + ", " + list[6])
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as! BuildingManageTableViewCell
        cell.setBuildingViewFeed(buildingName: buildingName, lastCheckInTime: buildingTime, checkIn: checkIn)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let alert = UIAlertController(title: "Building Info", message: "Choose an option.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Get QR Code", style: .default, handler: { (action) in
//            self.performSegue(withIdentifier: "QRCodeVC", sender: self)
//        }))
//        alert.addAction(UIAlertAction(title: "Get Building Info", style: .default, handler: { (action) in
//            self.performSegue(withIdentifier: "buildingInfoVC", sender: self)
//        }))
//        self.present(alert, animated: true)
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? GenerateQRViewController {
//            destination.modalPresentationStyle = .fullScreen
//            let index = tableView.indexPathForSelectedRow?.row
//            destination.buildingName = buildings[index!].buildingName
//        }
//        if let destination2 = segue.destination as? BuildingXXXViewController {
//            destination2.modalPresentationStyle = .fullScreen
//            let index = tableView.indexPathForSelectedRow?.row
//            destination2.buildingName = buildings[index!].buildingName
//
//        }
//    }
    
}

