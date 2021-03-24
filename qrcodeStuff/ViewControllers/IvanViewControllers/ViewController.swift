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
    
    var userData : UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
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
                    
//                    var user = Auth.auth().currentUser
//                    // Setting current userData
//                    if let email = user?.email {
//                        self.userData = UserData(email)
//                    }
                    
                    // Directing to respective views
//                    if (!(self.userData?.isStudent())!) {
//                        print("transitioning to manager view");
//                        self.transitionToManagerView(user: user?);
//                    } else{
//                        print("transitioning to student view");
//                        self.transitionToStudentView(user: user?);
//                    }
                }
            }
        }
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToStudentView(user: User) {
        
        let studentTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.studentTabController) as! StudentTabBarController
        
        studentTabController.user = user
        studentTabController.userData = self.userData
        
        view.window?.rootViewController = studentTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToManagerView(user: User) {
        
        let managerTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.managerTabController) as! ManagerTabBarController
        
        managerTabController.user = user
        managerTabController.userData = self.userData
        
        view.window?.rootViewController = managerTabController
        view.window?.makeKeyAndVisible()
        
    }
    
}

