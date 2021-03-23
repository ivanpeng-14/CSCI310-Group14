//
//  DeleteAccountViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import FirebaseAuth

class DeleteAccountViewController: UIViewController, UITextFieldDelegate {
    
    // Current User
    var user : User?
    var userData : UserData?
    
    // Buttons
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Text Fields
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        if self.user == nil {
            self.user = Auth.auth().currentUser
            if let email = self.user?.email {
                self.userData = UserData(email)
            }
        }
        
        super.viewDidLoad()
        
        password.delegate = self
        confirmPassword.delegate = self
    }
    
    // Required by Protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != ""
    }
    
    // IB Actions
    @IBAction func deleteConfirmed(_ sender: UIButton) {
        self.userData?.updateData(key: "deleted", val: true)
    }

}
