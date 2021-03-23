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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
        displayUserData()
    }
    
    func loadData() {
//        let db = Firestore.firestore()
        service = BuildingService()
              service?.get(collectionID: "buildings") { buildings in
             self.allbuildings = buildings
         }
        
    }
    
    func displayUserData() {
//        let user = Auth.auth().currentUser
//        if let user = user {
//          // The user's ID, unique to the Firebase project.
//          // Do NOT use this value to authenticate with your backend server,
//          // if you have one. Use getTokenWithCompletion:completion: instead.
//          let uid = user.uid
//          let email = user.email
//
//          var multiFactorString = "MultiFactor: "
//          for info in user.multiFactor.enrolledFactors {
//            multiFactorString += info.displayName ?? "[DispayName]"
//            multiFactorString += " "
//          }
//          // ...
//        }
        let db = Firestore.firestore()
//        let docRef = db.collection("cities").document("SF")
        let user = Auth.auth().currentUser
        let userUID = ""
        if let user = user {
            let userUID = user.uid
            print(userUID)
        }
        
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                print("Document data: \(dataDescription)")
//            } else {
//                print("Document does not exist")
//            }
//        }
        
        db.collection("students").document(userUID).addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
              print("Current data: \(data)")
              let firstName = data["firstName"] as? String ?? ""
              let email = data["uscEmail"] as? String ?? ""
              print(firstName)
              print(email)
            }
    }
    
//    func fetchData() {
//            db.collection("users").addSnapshotListener { (querySnapshot, error) in
//                let documents = querySnapshot?.documents else {
//                    print("No documents")
//                }
//
//                let docMap = documents.map { (queryDocumentSnapshot) -> User in
//                    let data = queryDocumentSnapshot.data()
//                    let name = data["name"] as? String ?? ""
//                    let surname = data["surname"] as? String ?? ""
//                    print(name)
//                }
//            }
//    }
    
    
}
extension StudentVisitHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let buildingName = buildings[indexPath.row].buildingName
        let buildingCurrentCapacity = String(buildings[indexPath.row].currentCapacity)
        let buildingTotalCapacity = String(buildings[indexPath.row].totalCapacity)
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as! BuildingManageTableViewCell
        cell.setBuilding(buildingName: buildingName, buildingCurrentCapacity: buildingCurrentCapacity, buildingTotalCapacity: buildingTotalCapacity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Building Info", message: "Choose an option.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Get QR Code", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "QRCodeVC", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Get Building Info", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "buildingInfoVC", sender: self)
        }))
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GenerateQRViewController {
            destination.modalPresentationStyle = .fullScreen
            let index = tableView.indexPathForSelectedRow?.row
            destination.buildingName = buildings[index!].buildingName
        }
        if let destination2 = segue.destination as? BuildingXXXViewController {
            destination2.modalPresentationStyle = .fullScreen
            let index = tableView.indexPathForSelectedRow?.row
            destination2.buildingName = buildings[index!].buildingName
            
        }
    }
    
}

