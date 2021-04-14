//
//  BuildingManualEditViewController.swift
//  qrcodeStuff
//
//  Created by Serena He on 4/13/21.
//

import UIKit
import FirebaseFirestore

class BuildingManualEditViewController: UIViewController {

    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var buildingNewTotalCapacityTextField: UITextField!
    @IBOutlet weak var buildingTotalCapacityContentLabel: UILabel!
    @IBOutlet weak var buildingCurrentCapacityContentLabel: UILabel!
    @IBOutlet weak var buildingNameContentLabel: UILabel!
    var buildingName: String?
    var buildingCurrentCapacity: Int?
    var buildingTotalCapacity: Int?
    
    func loadData(buildingID: String) {
        let db = Firestore.firestore()
        db.collection("buildings").document(buildingID).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }

            //print("Current data: \(data)")
            let currNum = data["currentCapacity"] as? Int ?? -1
            let totalNum = data["totalCapacity"] as? Int ?? -1
            let bName = data["buildingName"] as? String ?? "NULL"
            self.buildingCurrentCapacityContentLabel.text = "\(currNum)"
            self.buildingTotalCapacityContentLabel.text = "\(totalNum)"
            self.buildingNameContentLabel.text = bName;
            
            self.buildingName = bName;
            self.buildingCurrentCapacity = currNum;
            self.buildingTotalCapacity = totalNum;
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.buildingNameContentLabel.text = buildingName!
    
        
        let db = Firestore.firestore()

        db.collection("buildings").whereField("buildingName", isEqualTo: self.buildingName!).getDocuments { (querySnapshot, error) in
            if error == nil {
                for document in querySnapshot!.documents {
                    let buildingID = document.documentID
                    self.loadData(buildingID: buildingID)
        
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
