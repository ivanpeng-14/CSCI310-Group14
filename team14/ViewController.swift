//
//  ViewController.swift
//  team14
//
//  Created by Serena He on 3/17/21.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController, UIDocumentPickerDelegate{
    
    @IBOutlet weak var uploadStatusLabel: UILabel!
    
    @IBOutlet weak var firebaseStatusLabel: UILabel!
    
    @IBAction func uploadCSVButtonClick(_ sender: Any) {
        print ("clicked")
        let types = UTType.types(tag: "json",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(
                forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
        
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
    }
    
    

}

