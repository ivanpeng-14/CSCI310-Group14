//
//  StudentSignUpViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/21/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class StudentSignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var uscEmailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var uscStudentIDTextField: UITextField!
    
    @IBOutlet weak var majorTextField: UITextField!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
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
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            uscStudentIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
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
            
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = uscEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let uscID = uscStudentIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let major = majorTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                // Check for errors
                if err != nil {
                    
                    // There was an error creating the user
                    let errorMessage = err!.localizedDescription
                    print(errorMessage)
                    self.errorLabel.text = errorMessage
//                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("students").addDocument(data: ["firstname":firstName, "lastname":lastName, "USC email":email, "password":password, "USC ID": uscID, "Major":major, "isManager": false, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error adding student data")
                        }
                    }
                    
                    // Transition to the home screen
                    print("Student successfully signed up!")
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
