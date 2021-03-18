//
//  ViewController.swift
//  team14
//
//  Created by Serena He on 3/17/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import SwiftCSV
import Firebase

class ViewController: UIViewController, UIDocumentPickerDelegate{
    
    @IBOutlet weak var uploadStatusLabel: UILabel!
    
    @IBOutlet weak var firebaseStatusLabel: UILabel!
    
    @IBAction func uploadCSVButtonClick(_ sender: Any) {
        print ("clicked")
        let supportedfiles : [UTType] = [UTType.data]
        
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
            db.collection("buildingsTEST").addDocument(data: [
                                                        "header": csvFile.header, "namedRows": csvFile.namedRows, "namedColumns" : csvFile.namedColumns]
            ) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        } catch {
            // Catch errors from trying to load files
            print("csverror")
        }
        
    }
}


