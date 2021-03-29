//
//  AddBuildingViewController.swift
//  TrojanCheckInAndOut
//
//  Created by Serena He on 3/21/21.
//  Copyright © 2021 Claire Jutabha. All rights reserved.
//


import UIKit
import FirebaseFirestore
import SwiftCSV
import MobileCoreServices
import UniformTypeIdentifiers

class AddBuildingViewController: UIViewController, UIDocumentPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var errorLabel1: UILabel!

    @IBOutlet weak var errorLabel2: UILabel!

    //MARK: Properties

    @IBOutlet weak var buildingNameTextField: UITextField!
    
    @IBOutlet weak var capacityTextField: UITextField!
    
    func setUpElements() {
        errorLabel1.alpha = 0;
        errorLabel2.alpha = 0;
    }
    
    @IBAction func addBuildingButton(_ sender: Any) {
        let db = Firestore.firestore()
        var alreadyExists = false;
        db.collection("buildings").whereField("buildingName", isEqualTo: buildingNameTextField.text).getDocuments(){(querySnapshot, err) in
            if ((querySnapshot?.isEmpty) == false) {
                // building already exist
                self.errorLabel1.text = "Building Already Exists";
                self.errorLabel1.textColor = UIColor.red;
                self.errorLabel1.alpha = 1;
            } else {
                // building doesn't already exist
                self.errorLabel1.alpha = 0;
                db.collection("buildings").addDocument(data: [
                    "buildingName": self.buildingNameTextField.text ,
                    "totalCapacity": Int(self.capacityTextField.text ?? "0"),
                    "currentCapacity": 0,
                    "currentStudents" : []
                    
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                        self.errorLabel1.text = "Error writing document: \(err)"
                        self.errorLabel1.textColor = UIColor.red;
                    } else {
                        print("Document successfully written!")
                        self.errorLabel1.text = "Building successfully added!"
                        self.errorLabel1.textColor = UIColor.green;
                        self.buildingNameTextField.text = "";
                        self.capacityTextField.text = "";
                    }
                    self.errorLabel1.alpha = 1;
                }
            }
        };
        
        
    }
    
    @IBAction func uploadCSVButton(_ sender: UIButton) {
        let supportedfiles : [UTType] = [UTType.commaSeparatedText]
                
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedfiles, asCopy: true)
        
        controller.delegate = self
        controller.allowsMultipleSelection = false
        
        present(controller, animated: true, completion: nil)

    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt docurl: URL) {
        print("a file was selected")
        print("path: \(docurl.absoluteString)")
        do {
            // From a file (with errors)
            let csvFile: CSV = try CSV(url: docurl)
            print(csvFile.header)
            print(csvFile.namedRows)
            print(csvFile.namedColumns)
                        
            // update Buildings in firestore
            let db = Firestore.firestore()
            for arrItem in csvFile.namedRows {
                print(arrItem);
                db.collection("buildings").addDocument(data: [
                    "buildingName": arrItem["buildingName"]! , "totalCapacity": Int(arrItem["totalCapacity"]!) ?? 0,
                    "currentCapacity": 0,
                    "currentStudents" : []
                    
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
            
        } catch {
            // Catch errors from trying to load files
            print("csverror")
        }
    }
}
