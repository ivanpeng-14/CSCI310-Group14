//
//  SuccessViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/22/21.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goBackButton(_ sender: Any) {
        print("Tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StudentTC") as! StudentTabBarController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
