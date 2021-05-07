//
//  BuildingManualEditViewController.swift
//  qrcodeStuff
//
//  Created by Serena He on 4/13/21.
//

import UIKit
import FirebaseFirestore

class BuildingManualEditViewController: UIViewController {

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
        errorLabel.alpha = 0;
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
    
    @IBAction func updateButton(_ sender: Any) {
        // if new capacity field empty
        if (buildingNewTotalCapacityTextField.text == "") {
            errorLabel.text = "Invalid New Capacity";
            errorLabel.textColor = UIColor.red;
            errorLabel.alpha = 1;
            return;
        }
        // if new capacity field less than 0 or not a number
        let newTotalCapacity = (Int(buildingNewTotalCapacityTextField.text ?? "-1") ?? -1);
        if (newTotalCapacity < 1) {
            errorLabel.text = "Invalid Capacity";
            errorLabel.textColor = UIColor.red;
            errorLabel.alpha = 1;
            return;
        }
        // if new capacity field less than current capacity
        if (newTotalCapacity < buildingCurrentCapacity ?? 0) {
            errorLabel.text = "New Capacity > Current Capacity";
            errorLabel.textColor = UIColor.red;
            errorLabel.alpha = 1;
            return;
        }
        // proceed
        let db = Firestore.firestore()
        db.collection("buildings").whereField("buildingName", isEqualTo: buildingName).getDocuments(){(querySnapshot, err) in
            if ((querySnapshot?.isEmpty) == false) {
                // building already exist
                self.errorLabel.alpha = 0;
                
                db.collection("buildings").document((querySnapshot?.documents.first!.documentID)!).updateData(
                    ["totalCapacity" :newTotalCapacity]
                );
                self.errorLabel.text = "Capacity Changed";
                self.errorLabel.textColor = UIColor.green;
                self.errorLabel.alpha = 1;
            } else {
                // building doesn't already exist
                self.errorLabel.text = "Internal Error: Building Doesn't Exist";
                self.errorLabel.textColor = UIColor.red;
                self.errorLabel.alpha = 1;
                
            }
        };
        return
    }
    @IBAction func removeButton(_ sender: Any) {
        // if current capacity not 0
        if (buildingCurrentCapacity ?? 0 != 0) {
            errorLabel.text = "Building not empty; can't delete";
            errorLabel.textColor = UIColor.red;
            errorLabel.alpha = 1;
            return;
        }
        // proceed
        let db = Firestore.firestore()
        db.collection("buildings").whereField("buildingName", isEqualTo: buildingName).getDocuments(){(querySnapshot, err) in
            if ((querySnapshot?.isEmpty) == false) {
                // building already exist
                self.errorLabel.alpha = 0;
                
                db.collection("buildings").document((querySnapshot?.documents.first!.documentID)!).delete();
                self.errorLabel.text = "Building Deleted";
                self.errorLabel.textColor = UIColor.green;
                self.errorLabel.alpha = 1;
            } else {
                // building doesn't already exist
                self.errorLabel.text = "Internal Error: Building Doesn't Exist";
                self.errorLabel.textColor = UIColor.red;
                self.errorLabel.alpha = 1;
                
            }
        };
        return
    }
}
