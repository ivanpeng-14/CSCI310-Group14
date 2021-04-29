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

    var isUpdate = false;
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var csvStatusLabel: UILabel!
    
    @IBOutlet weak var errorLabel1: UILabel!

    @IBOutlet weak var errorLabel2: UILabel!

    //MARK: Properties

    @IBOutlet weak var buildingNameTextField: UITextField!
    
    @IBOutlet weak var capacityTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: csvStatusLabel.bottomAnchor).isActive = true;
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
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
        self.isUpdate = true;
        let supportedfiles : [UTType] = [UTType.commaSeparatedText]
                
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: supportedfiles, asCopy: true)
        
        controller.delegate = self
        controller.allowsMultipleSelection = false
        
        present(controller, animated: true, completion: nil)

    }
    
    @IBAction func addCSVButton(_ sender: Any) {
        self.isUpdate = false;
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
                let validAttributes = [
                    NSAttributedString.Key.foregroundColor : UIColor.green, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
                ];
                let invalidAttributes = [
                    NSAttributedString.Key.foregroundColor : UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)
                ];
                
                csvStatusLabel.attributedText = NSMutableAttributedString();
                
                self.csvStatusLabel.attributedText = NSMutableAttributedString(string: "");
                
                // update Buildings in firestore
                let db = Firestore.firestore()
                for arrItem in csvFile.namedRows {
                    print(arrItem);
                    db.collection("buildings").whereField("buildingName", isEqualTo: arrItem["buildingName"]).getDocuments(){(querySnapshot, err) in
                        if ((querySnapshot?.isEmpty) == false) {
                            print("valid")
                            
                            // building already exist
                            if (self.isUpdate) {
                                // check to make sure current number of students <= new capacity
                                let currCapacity = (querySnapshot?.documents.first!.get("currentCapacity"))! as! Int;
                                let totalCapacity = Int(arrItem["totalCapacity"]!) ?? 0;
                                
                                // valid
                                if (currCapacity < totalCapacity) {
                                    let currstring = self.csvStatusLabel.attributedText;
                                    let string = NSMutableAttributedString();
                                    string.append(currstring!);
                                    string.append(NSAttributedString(string: "\(String(arrItem["buildingName"]!) )'s capacity updated to \(String(arrItem["totalCapacity"]!) ) \n", attributes: validAttributes));
                                    self.csvStatusLabel.attributedText = string;
                                    
                                    db.collection("buildings").document((querySnapshot?.documents.first!.documentID)!).updateData(["totalCapacity" :Int(arrItem["totalCapacity"]!) ?? 0 ]);
                                }
                                // invalid
                                else {
                                    print("invalid")
                                    let currstring = self.csvStatusLabel.attributedText;
                                    let string = NSMutableAttributedString();
                                    string.append(currstring!);
                                    string.append(NSAttributedString(string: "\(String(arrItem["buildingName"]!) )'s currentCapacity exceeds \(String(arrItem["totalCapacity"]!) ) \n", attributes: invalidAttributes));
                                    self.csvStatusLabel.attributedText = string;
                                }
                            } else {
                                print("invalid")
                                let currstring = self.csvStatusLabel.attributedText;
                                let string = NSMutableAttributedString();
                                string.append(currstring!);
                                string.append(NSAttributedString(string: "\(String(arrItem["buildingName"]!) ) already exists! Can't Add.\n", attributes: invalidAttributes));
                                self.csvStatusLabel.attributedText = string;
                            }
                            
                            
                            
                            
                        } else {
                            if(self.isUpdate) {
                                print("invalid")
                                let currstring = self.csvStatusLabel.attributedText;
                                let string = NSMutableAttributedString();
                                string.append(currstring!);
                                string.append(NSAttributedString(string: "\(String(arrItem["buildingName"]!) ) is not an existing building \n", attributes: invalidAttributes));
                                self.csvStatusLabel.attributedText = string;
                            } else {
                                let currstring = self.csvStatusLabel.attributedText;
                                let string = NSMutableAttributedString();
                                string.append(currstring!);
                                string.append(NSAttributedString(string: "\(String(arrItem["buildingName"]!) ) has been created wth capacity \(String(arrItem["totalCapacity"]!) ) \n", attributes: validAttributes));
                                self.csvStatusLabel.attributedText = string;
                                
                                db.collection("buildings").addDocument(data: [
                                    "buildingName": arrItem["buildingName"]! , "totalCapacity": Int(arrItem["totalCapacity"]!) ?? 0,
                                    "currentCapacity": 0,
                                    "currentStudents" : []
                                    
                                ]);
                            }
                            
                            // building doesn't already exist

                            /**db.collection("buildings").addDocument(data: [
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
                            }**/
                        }

                    }
                }
                if (errorLabel2.alpha == 0) {
                    errorLabel2.textColor = UIColor.green;
                    errorLabel2.text = "Valid Formatted CSV!"
                    //print("finalstring: <\(string)>");
                    //
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
