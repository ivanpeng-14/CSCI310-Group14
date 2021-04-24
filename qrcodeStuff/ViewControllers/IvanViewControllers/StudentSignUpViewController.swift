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
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        uscEmailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        uscStudentIDTextField.delegate = self
        majorTextField.delegate = self
    }
    
    var selectedMajor = String()
    var majorList = [
        "Aerospace Engineering",
        "Mechanical Engineering",
        "Astronautical Engineering",
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
        let uscID = uscStudentIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let major = majorTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check all fields are filled
        if firstName == "" ||
            lastName == "" ||
            email == "" ||
            password == "" ||
            confirm == "" ||
            uscID == "" ||
            major == "" {
            
            return "Please fill in all fields."
        }
        
        // Check that email is @usc.edu
        if email?.range(of: "@usc.edu") == nil {
            
            return "You must sign up with a USC email."
        }
        
        // Check password == confirmPassword
        if password != confirm {
            return "Passwords must match."
        }
        
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
            let kickOut = ""
            
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
                        "uscid": uscID,
                        "major": major,
                        "ismanager": isManager,
                        "deleted": deleteStatus,
                        "currbuilding": currBuilding,
                        "lastcheckin": lastCheckIn,
                        "uid": uid,
                        "photo": "F29248B7-72C2-47C6-AE85-7F687071373F",
                        "kickOut": kickOut
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
