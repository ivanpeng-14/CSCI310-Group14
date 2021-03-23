//
//  GenerateQRViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/15/21.
//

import UIKit
import FirebaseFirestore

class GenerateQRViewController: UIViewController {

    @IBOutlet weak var qrImage: UIImageView!
    
    
    @IBAction func backButton(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ManagerTC") as! ManagerTabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    var buildingName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getBuilding(buildingName: self.buildingName!)
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func getBuilding(buildingName: String) {
        let image = self.generateQRCode(from: buildingName)
        self.qrImage.image = image
//        let db = Firestore.firestore()
//        db.collection("buildings").document(buildingName).getDocument { (document, error) in
//            if error == nil {
//                //check if document exists
//                if document != nil && document!.exists {
//                    // let documentData = document!.data()
//                    let image = self.generateQRCode(from: buildingName)
//                    self.qrImage.image = image
//                }
//                else {
//                    print("ERRRor")
//                }
//            }
//            else {
//                print("error")
//            }
//        }
        
    }

    
}
