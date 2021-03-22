//
//  HomeViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/21/21.
//

import UIKit

// Welcome screen after successful login/signup
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func returnTapped(_ sender: Any) {
        self.transitionToLogin()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func transitionToLogin() {
        
        let loginViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.loginViewController) as? ViewController

        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
        
    }
}
