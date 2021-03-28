//
//  ScannerViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/15/21.
//

import UIKit
import AVFoundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var squareBorder: UIImageView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    

    var studentID = ""
    var buildingID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // plz workkkkk
        self.studentID = (Auth.auth().currentUser?.email)!
        print("current student \(self.studentID)")
        
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        
        self.view.bringSubviewToFront(squareBorder)
        
        
        
        captureSession.startRunning()
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
     
            getBuildingName(buildingName: stringValue)
        }

    
    }
    
    func found(curr: Int, total:Int, buildingID: String, buildingName: String) -> String {
        var message: String
        message = ""
       // building is at capacity
        if curr >= total
        {
            message = "AT CAPACITY"
            let alert = UIAlertController(title: "Building at Capacity", message: "There are currently \(curr) out of \(total) students in \(buildingName). Sorry lol", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                       self.viewDidLoad()
            }))
            self.present(alert, animated: true)
        }
        else
        {
            message = "NOT AT CAPACITY"
            let db = Firestore.firestore()

            db.collection("students").document(studentID).getDocument { (document, error) in //change to actual student later!!!
                if error == nil {
                    //check if document exists
                    if document != nil && document!.exists {
                        let documentData = document!.data()
                        let currentBuilding = documentData!["currbuilding"] as? String ?? "-1"
                        self.displayAlert(studentBuilding: currentBuilding, curr: curr, total: total, buildingID: buildingID, buildingName: buildingName)

                    }
                }
                else {
                    print("found() error")
                }
            }
       
        }
        return message
      
    }
    
    func displayAlert(studentBuilding: String, curr: Int, total:Int, buildingID: String, buildingName: String) -> String
    {
        var message: String
        // student is checked into the building already, and can check out
        message = ""
        if studentBuilding == buildingID
        {
            message = "Already checked in, can check out now."
            let alert = UIAlertController(title: "Check Out", message: "Check out of \(buildingName)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                //update database
                let db = Firestore.firestore()

                //update building history
                let buildingHistory = db.collection("buildings").document(buildingID)

                buildingHistory.updateData(["currentStudents" : FieldValue.arrayRemove([self.studentID])])

                //update capacity
                let newCapacity = curr - 1
                buildingHistory.updateData(["currentCapacity": newCapacity])

                //update students currBuilding
                let studentDoc = db.collection("students").document(self.studentID)
                studentDoc.updateData(["currbuilding": ""])

                //update student history
                let studentHistory = db.collection("students").document(self.studentID)
                studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked out of \(buildingName) at \(Date())"])])
                

                let alert2 = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    self.viewDidLoad()
                }))
                self.present(alert2, animated: true)
                
                
            }))
            self.present(alert, animated: true)
        }
        //student can check into this building
        else if studentBuilding == ""
        {
            message = "Not checked in anywhere, can check in now"
            let alert = UIAlertController(title: "Check In", message: "There are currently \(curr) out of \(total) students in this building. Check in to \(buildingName)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                //update database
                let db = Firestore.firestore()
                //update building history
                let buildingHistory = db.collection("buildings").document(buildingID)
                buildingHistory.updateData(["currentStudents" : FieldValue.arrayUnion([self.studentID])])
                
                //update capacity
                let newCapacity = curr + 1
                buildingHistory.updateData(["currentCapacity": newCapacity])
                
                //update students currBuilding
                let studentDoc = db.collection("students").document(self.studentID)
                studentDoc.updateData(["currbuilding": buildingID])
                studentDoc.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked into \(buildingName) at \(Date())"])])
                studentDoc.updateData(["lastcheckin": "\(Date())"])
                
                let alert2 = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    self.viewDidLoad()
                }))
                self.present(alert2, animated: true)
            }))
            self.present(alert, animated: true)
        }
        //student is not checked into the building, but needs to check out of another building
        else
        {
            message = "Needs to check out first."
            let db = Firestore.firestore()
            db.collection("buildings").document(studentBuilding).getDocument { (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        let studentBuildingName = document!.data()!["buildingName"] as? String ?? ""
                        let alert = UIAlertController(title: "Error", message: "Please check out of \(studentBuildingName) before checking in to \(buildingName).", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                            self.viewDidLoad()
                        }))
                        self.present(alert, animated: true)
                    }
                }
            }
            
        }
        
        return message
    }
    
    //get building name from qr code
    func getBuildingName(buildingName: String) {
        let db = Firestore.firestore()
        print(buildingName)
        // find building name
        db.collection("buildings").whereField("buildingName", isEqualTo: buildingName).getDocuments { (querySnapshot, error) in
            if error == nil {
                for document in querySnapshot!.documents{
                    self.buildingID = document.documentID
                    print(self.buildingID)
                    db.collection("buildings").document(self.buildingID).getDocument { (document, error) in
                        if error == nil {
                            //check if document exists
                            if document != nil && document!.exists {
                                self.getCapacity(buildingID: self.buildingID, buildingName: buildingName)
                            }
                            else
                            {
                                print("Building does not exist")
                                let alert = UIAlertController(title: "Building does not exist", message: "", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: { (action) in
                                    self.viewDidLoad()
                                }))
                                self.present(alert, animated: true)
                            }
                        }
                        else {
                            print("Building does not exist")
                        }
                    }
                }
            }
            else {
                print("does not exist")
            }
        }
    }
    
    // building should exist at this point
    // _ completion: @escaping (_ curr: Int, _ total: Int) -> String
    func getCapacity(buildingID: String, buildingName: String)
    {
        let db = Firestore.firestore()

        db.collection("buildings").document(buildingID).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    //print(documentData!)
                    let currentCapacity = documentData!["currentCapacity"] as? Int ?? -1
                    let totalCapacity = documentData!["totalCapacity"] as? Int ?? -1
                    self.found(curr: currentCapacity, total: totalCapacity, buildingID: buildingID, buildingName: buildingName)
                }
             
            }
            else {
                print("Building does not exist")
            }
            
        }
   
    }
    

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
