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

class StudentSignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

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
        createPickerView()
        dismissPickerView()
    }
    
    var selectedMajor = String()
    var majorList = [
        "Aerospace Engineering",
        "Mechanical Engineering",
        "Astronatuical Engineering",
        "Biomedical Engineering",
        "Chemical Engineering",
        "Civil Engineering",
        "Environmental Engineering",
        "Computer Science",
        "Computer Science and Business Administration",
        "Electrical Engineering",
        "Computer Engineering",
        "Industrial and Systems Engineering"
    ]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortMajors()
        return majorList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return majorList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedMajor = majorList[row] // selected item
        majorTextField.text = selectedMajor
    }
    
    func sortMajors() {
        majorList.sort()
    }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           majorTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       majorTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
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
        if uscEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).range(of: "@usc.edu") == nil {
            
            return "You must sign up with an USC email."
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
            let uscID = uscStudentIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let major = majorTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let isManager = false
            let deleteStatus = false
            let currBuilding = ""
            let lastCheckIn = ""
            
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
                        "uscID": uscID,
                        "major": major,
                        "isManager": isManager,
                        "deleteStatus": deleteStatus,
                        "currBuilding": currBuilding,
                        "lastCheckIn": lastCheckIn,
                        "uid": uid
                    ]
                    db.collection("students").document(email).setData(studentData) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            self.showError("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
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
