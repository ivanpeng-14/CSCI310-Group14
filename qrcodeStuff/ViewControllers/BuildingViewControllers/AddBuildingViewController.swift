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
        // check if building name not supplied
        if (buildingNameTextField.text == "") {
            errorLabel1.text = "Invalid building name";
            errorLabel1.textColor = UIColor.red;
            errorLabel1.alpha = 1;
            return;
        }
        // check if capacity not a number or if capacity is less than 1
        if ((Int(capacityTextField.text ?? "-1") ?? -1) < 1) {
            errorLabel1.text = "Invalid capacity";
            errorLabel1.textColor = UIColor.red;
            errorLabel1.alpha = 1;
            return;
        }
        
        let db = Firestore.firestore()
        var alreadyExists = false;
        db.collection("buildings").whereField("buildingName", isEqualTo: buildingNameTextField.text).getDocuments(){(querySnapshot, err) in
            if ((querySnapshot?.isEmpty) == false) {
                // building already exist
                self.errorLabel1.text = "Building already exists";
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
        errorLabel2.alpha = 0;
        do {
            // From a file (with errors)
            let csvFile: CSV = try CSV(url: docurl)
            print(csvFile.header)
            print(csvFile.namedRows)
            print(csvFile.namedColumns)
            
            var properlyFormatted = true;
            // validate CSV format
            // check if more than 2 columns
            if (csvFile.namedColumns.count != 2 ) {
                properlyFormatted = false;
                errorLabel2.text = "Invalid format: more than 2 columns";
            }
            // check if second column not all numbers or less than 0
            for arrItem in csvFile.namedRows {
                print(arrItem);
                let totalCapacity = Int(arrItem["totalCapacity"] ?? "-1")
                if ( totalCapacity == -1) {
                    properlyFormatted = false;
                    errorLabel2.text = "Invalid format: NaN provided for capacity";
                    break;
                }
                else if (totalCapacity ?? -1 < 0) {
                    properlyFormatted = false;
                    errorLabel2.text = "Invalid format: capacity less than 0 provided";
                    break;
                }
            }
            
            if (properlyFormatted) {
                
                // update Buildings in firestore
                let db = Firestore.firestore()
                for arrItem in csvFile.namedRows {
                    print(arrItem);
                    db.collection("buildings").whereField("buildingName", isEqualTo: buildingNameTextField.text).getDocuments(){(querySnapshot, err) in
                        if ((querySnapshot?.isEmpty) == false) {
                            // building already exist
                            db.collection("buildings").document((querySnapshot?.documents.first!.documentID)!).updateData(["totalCapacity" :Int(arrItem["totalCapacity"]!) ?? 0 ]);
                        } else {
                            // building doesn't already exist
                            db.collection("buildings").addDocument(data: [
                                "buildingName": arrItem["buildingName"]! , "totalCapacity": Int(arrItem["totalCapacity"]!) ?? 0,
                                "currentCapacity": 0,
                                "currentStudents" : []
                                
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                    self.errorLabel2.text = "Invalidly formatted CSV";
                                    self.errorLabel2.textColor = UIColor.red;
                                    self.errorLabel2.alpha = 1;
                                } else {
                                    print("Document successfully written!")
                                }
                            }
                        }
                    }
                }
                if (errorLabel2.alpha == 0) {
                    errorLabel2.textColor = UIColor.green;
                    errorLabel2.text = "Buildings successfully added"
                }
            } else {
                self.errorLabel2.textColor = UIColor.red;
            }
            errorLabel2.alpha = 1;
            
        } catch {
            // Catch errors from trying to load files
            print("csverror")
        }
    }
}
