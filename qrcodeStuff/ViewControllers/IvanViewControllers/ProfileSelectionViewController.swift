//
//  ProfileSelectionViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/21/21.
//

import UIKit

class ProfileSelectionViewController: UIViewController {

    @IBOutlet weak var studentButton: UIButton!
    
    @IBOutlet weak var managerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func StudentSignUpTapped(_ sender: Any) {
        
        print("Student sign up tapped!")
    }
    
    @IBAction func ManagerSignUpTapped(_ sender: Any) {
        
        print("Manager sign up tapped!")
    }
    
}
