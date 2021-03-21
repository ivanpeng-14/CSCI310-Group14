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

        // Do any additional setup after loading the view.
    }
    
    //MARK: Properties

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
                db.collection("buildings").document(arrItem["buildingName"]!).setData( [
                    "totalCapacity": Int(arrItem["totalCapacity"]!) ?? 0,
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
