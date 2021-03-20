//
//  EditBuildingViewController.swift
//  TrojanCheckInAndOut
//
//  Created by Claire Jutabha on 3/20/21.
//  Copyright © 2021 Claire Jutabha. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EditBuildingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Properties
    
    @IBOutlet weak var buildingNameLabel: UITextField!
    @IBOutlet weak var buildingCapacityLabel: UITextField!
    
    @IBAction func ButtonPressed(_ sender: UIButton) {
        
    }
    func editBuilding(){
        let db = Firestore.firestore()

        db.collection("buildings").document("building name").setData([
            "name": "new name",
            "currentCapacity": 0,
            "totalCapacity": 000
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
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
