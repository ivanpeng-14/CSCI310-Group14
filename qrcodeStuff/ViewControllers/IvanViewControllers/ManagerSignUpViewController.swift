//
//  ManagerSignUpViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/21/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ManagerSignUpViewController: UIViewController, UITextFieldDelegate {

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
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        uscEmailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("pressed return")
        textField.resignFirstResponder()
        return false
    }
    
    // Returns nil if correct, otherwise returns error label as String message
    func validateFields() -> String? {
        let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = uscEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirm = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        // Check all fields are filled
        if firstName == "" ||
            lastName == "" ||
            email == "" ||
            password == "" ||
            confirm == "" {
            
            return "Please fill in all fields."
        }
        if email?.range(of: "@usc.edu") == nil {
            
            return "You must sign up with a USC email."
        }
        if password != confirm {
            return "Passwords must match."
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
            let isManager = true
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
                        "firstname": firstName,
                        "lastname": lastName,
                        "email": email,
                        "password": password,
                        "ismanager": isManager,
                        "deleted": deleteStatus,
                        "buildingList": buildingList,
                        "uid": uid
                    ]
                    db.collection("manager").document(email).setData(studentData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            self.showError("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    print("Successfully created Manager!")
                    
                    // Send email
                    EmailSender().verificationEmail(for: email, name: firstName)
                    
                    // Transition to the home screen
                    self.performSegue(withIdentifier: "UploadPhoto", sender: self)
                }
                
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
