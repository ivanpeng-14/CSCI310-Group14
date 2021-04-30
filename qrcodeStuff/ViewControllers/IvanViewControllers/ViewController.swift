//
//  ViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/16/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var userData : UserData?
    var user: User?
    
    override func viewDidLoad() {
        print(Auth.auth().currentUser?.email ?? "no user logged in")
        super.viewDidLoad()
        setUpElements()
        if isLoggedIn() {
            print("Previously logged in!")
            let homevc = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.homeViewController) as! HomeViewController

            
            
            self.navigationController?.pushViewController(homevc, animated: false)
        }
        else {
            print("Previously NOT logged in!")
//            self.transitionToHome()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("pressed return")
        textField.resignFirstResponder()
        return false
    }
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
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
        
    var userEmail = ""
    
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
            
//            db.collection("students").document(userEmail).addSnapshotListener { documentSnapshot, error in
//                  guard let document = documentSnapshot else {
//                    print("Error fetching document: \(error!)")
//                    return
//                  }
//                  guard let data = document.data() else {
//                    print("Document data was empty.")
//                    return
//                  }
//    //              print("Current data: \(data)")
//                self.tempBuildingHistory = data["buildingHistory"] as? [String] ?? []
//                self.tempBuildingHistory.reverse()
//                print("buildingHistory: \(self.tempBuildingHistory)")
//                
//            }
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
                   
                    print("Error signing in")
                    
                    // Couldn't sign in
                    self.errorLabel.text = error!.localizedDescription
                    self.errorLabel.alpha = 1
                }
                else {
                   
                    var deleted : Bool?
                    
                    let currentUser = Auth.auth().currentUser
                    if let email = currentUser?.email {
                        
                        self.userEmail = email
                        self.userData = UserData(email) {
                            
                            deleted = self.userData?.getInfo("deleted") as? Bool
                          
                            if (deleted != nil) {
                                if (deleted!) {
                                    self.errorLabel.text = "This user account has been deleted. Please sign up with a new account!"
                                }
                                else {
                                    print("Successful login")
                                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                    UserDefaults.standard.synchronize()
                                    self.transitionToHome()
                                }
                            }
                            else {
                                print("Error: deleted was found nil")
                            }
                        }
                        
                    }
                    
                    
                }
            }
        }
        
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToStudentView() {
        
        let studentTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.studentTabController) as! StudentTabBarController
        
        studentTabController.user = self.user
        studentTabController.userData = self.userData
        
        view.window?.rootViewController = studentTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToManagerView() {
        
        let managerTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.managerTabController) as! ManagerTabBarController
        
        managerTabController.user = user
        managerTabController.userData = self.userData
        
        view.window?.rootViewController = managerTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.homeViewController) as? HomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}

