//
//  ViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/16/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
//        // this is our array of arrays
//        var groups = [[String]]()
//
//        // we create three simple string arrays for testing
//        var groupA = ["England", "Ireland", "Scotland", "Wales"]
//        var groupB = ["Canada", "Mexico", "United States"]
//        var groupC = ["China", "Japan", "South Korea"]
//
//        // then add them all to the "groups" array
//        groups.append(groupA)
//        groups.append(groupB)
//        groups.append(groupC)
//
//        // this will print out the array of arays
//        print("The groups are:", groups)
//
//        // we now append an item to one of the arrays
//        groups[1].append("Costa Rica")
//        print("\nAfter adding Costa Rica, the groups are:", groups)
//
//        // and now print out groupB's contents again
//        print("\nGroup B still contains:", groupB)
    }

    func setUpElements() {
        
        errorLabel.alpha = 0
    }
    
    // Returns nil if correct, otherwise returns error label as String message
    func validateFields() -> String? {
        
        // Check all fields are filled
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).range(of: "@usc.edu") == nil {
            
            return "You must sign in with a USC email."
        }
        
        // Check password strength -- TODO
        
        
        
        
        return nil
    }
        
    @IBAction func continueTapped(_ sender: Any) {
        
        // Validate fields
        let err = validateFields()
        
        if err != nil {
            
            // There's something wrong with the fields, show error message
            showError(err!)
        }
        else {
            // Clear previous error labels, if any
            showError("")
            
            // Create cleaned versions of the text field
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                    print("Error signing in")
                    
                    // Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                    
                    print("Successful login")
                    
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

