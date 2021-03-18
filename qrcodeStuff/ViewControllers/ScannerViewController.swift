//
//  ScannerViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/15/21.
//

import UIKit
import AVFoundation
import FirebaseFirestore

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var squareBorder: UIImageView!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var studentID = "DXUd2IZFa0gC9O1RVHumJSNGhkk2"

    override func viewDidLoad() {
        super.viewDidLoad()
        

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
     
            getBuildingName(code: stringValue)
        }

    
    }
    
    func found(curr: Int, total:Int, code: String) {
       // building is at capacity
        if curr >= total
        {
            let alert = UIAlertController(title: "Building at Capacity", message: "There are currently \(curr) out of \(total) students in this building. Sorry lol", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                       self.viewDidLoad()
            }))
            self.present(alert, animated: true)
        }
        else
        {
            let db = Firestore.firestore()
            
            db.collection("students").document(studentID).getDocument { (document, error) in //change to actual student later!!!
                if error == nil {
                    //check if document exists
                    if document != nil && document!.exists {
                        let documentData = document!.data()
                        let currentBuilding = documentData!["currBuilding"] as? String ?? "-1"
                        self.displayAlert(studentBuilding: currentBuilding, curr: curr, total: total, code: code)
                      
                    }
                }
                else {
                    print("found() error")
                }
            }
        }
      
    }
    func displayAlert(studentBuilding: String, curr: Int, total:Int, code: String)
    {
        // student is checked into the building already, and can check out
        if studentBuilding == code
        {
            let alert = UIAlertController(title: "Check Out", message: "Check out of \(code)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                //update database
                let db = Firestore.firestore()
            
                //update building history
                let buildingHistory = db.collection("buildings").document(code)
                buildingHistory.updateData(["checkInOutHistory" : FieldValue.arrayUnion(["studentIDTest checked out at \(Date())"])])
                
                //update capacity
                let newCapacity = curr - 1
                buildingHistory.updateData(["currentCapacity": newCapacity])
                
                //update students currBuilding
                let studentDoc = db.collection("students").document(self.studentID)
                studentDoc.updateData(["currBuilding": ""])
                
                
                //go to next screen
                let nextView = self.storyboard?.instantiateViewController(identifier: "CheckedVC")
                nextView?.modalPresentationStyle = .fullScreen
                self.present(nextView!, animated: true, completion: nil)
                
            }))
            self.present(alert, animated: true)
        }
        //student can check into this building
        else if studentBuilding == ""
        {
            let alert = UIAlertController(title: "Check In", message: "There are currently \(curr) out of \(total) students in this building. Check in to \(code)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                self.viewDidLoad()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
                //update database
                let db = Firestore.firestore()
                //update building history
                let buildingHistory = db.collection("buildings").document(code)
                buildingHistory.updateData(["checkInOutHistory" : FieldValue.arrayUnion(["studentIDTest checked in at  \(Date())"])])
                
                //update capacity
                let newCapacity = curr + 1
                buildingHistory.updateData(["currentCapacity": newCapacity])
                
                //update students currBuilding
                let studentDoc = db.collection("students").document(self.studentID)
                studentDoc.updateData(["currBuilding": code])
                
                //go to next screen
                let nextView = self.storyboard?.instantiateViewController(identifier: "CheckedVC")
                nextView?.modalPresentationStyle = .fullScreen
                self.present(nextView!, animated: true, completion: nil)
            }))
            self.present(alert, animated: true)
        }
        //student is not checked into the building, but needs to check out of another building
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please check out of \(studentBuilding) before checking in to \(code).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                self.viewDidLoad()
            }))
            self.present(alert, animated: true)
        }
        
        
    }
    
    //get building name from qr code
    func getBuildingName(code: String) {
        
        let db = Firestore.firestore()
        
        db.collection("buildings").document(code).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    // let documentData = document!.data()
                    self.getCapacity(buildingName: code)
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
    
    // building should exist at this point
    // _ completion: @escaping (_ curr: Int, _ total: Int) -> String
    func getCapacity(buildingName: String)
    {
        let db = Firestore.firestore()

        db.collection("buildings").document(buildingName).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    //print(documentData!)
                    let currentCapacity = documentData!["currentCapacity"] as? Int ?? -1
                    let totalCapacity = documentData!["totalCapacity"] as? Int ?? -1
                    self.found(curr: currentCapacity, total: totalCapacity, code: buildingName)
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
