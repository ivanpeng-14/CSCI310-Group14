//
//  ManagerSignUpViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/21/21.
//

import UIKit
import Firebase
import FirebaseAuth

class ManagerSignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var uscEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
        
    }
    
    // Returns nil if correct, otherwise returns error label as String message
    func validateFields() -> String? {
        
        // Check all fields are filled
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            uscEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check password strength -- TODO
        
        
        
        
        return nil
    }
    
    func setUpElements() {
        
        // Hide error Label
        errorLabel.alpha = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func createAccountTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Clear previous error labels, if any
            showError("")
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = uscEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let isManager = false
            let deleteStatus = false
            let buildingList: [String] = []
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    let errorMessage = err!.localizedDescription
                    print(errorMessage)
                    self.errorLabel.text = errorMessage
                    self.showError(errorMessage)
                }
                else {
                    
                    // Adding student document
                    let db = Firestore.firestore()
                    let uid = result!.user.uid
                    
                    let studentData: [String: Any] = [
                        "firstName": firstName,
                        "lastName": lastName,
                        "uscEmail": email,
                        "password": password,
                        "isManager": isManager,
                        "deleteStatus": deleteStatus,
                        "buildingList": buildingList,
                        "uid": uid
                    ]
                    db.collection("students").document(uid).setData(studentData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            self.showError("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    // Transition to the home screen
                    print("Successfully created Manager!")
                    self.transitionToHome()
                }
                
            }
            
            
            
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.homeViewController) as? HomeViewController

        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
        
    }
    
}
