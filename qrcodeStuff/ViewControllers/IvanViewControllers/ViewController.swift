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
        emailTextField.delegate = self
        passwordTextField.delegate = self
        setUpElements()
        if isLoggedIn() {
            // avoid app crashing
            if (Auth.auth().currentUser?.email == nil) {
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
            }
            
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
    
    @IBAction func resetPasswordTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Password", message: "Please enter a valid email for which you would like to change the password.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "student@usc.edu"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let text = textField?.text {
                if text == "" {
                    self.showResetError(isEmail: true)
                    return
                }
                Firestore.firestore().collection("students").document(text).getDocument { doc, err in
                    if doc?.data() == nil {
                        Firestore.firestore().collection("manager").document(text).getDocument { doc, err in
                            if doc?.data() == nil{
                                self.showResetError(isEmail: true)
                            }
                            else if let doc = doc{
                                let code = self.generateResetCode(email: text, name: doc.data()?["firstname"] as! String)
                                Auth.auth().signIn(withEmail: text, password: doc.data()?["password"] as! String, completion: {_,_ in
                                    self.requestCode(code, text, isManager: true)
                                })
                            }
                        }
                    }
                    else if let doc = doc {
                        let code = self.generateResetCode(email: text, name: doc.data()?["firstname"] as! String)
                        Auth.auth().signIn(withEmail: text, password: doc.data()?["password"] as! String, completion: {_,_ in
                            self.requestCode(code, text, isManager: false)
                        })
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateResetCode(email: String, name: String) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let code = String((0..<8).map{ _ in characters.randomElement()! })
        EmailSender().passwordResetEmail(for: email, name: name, code: code)
        return code
    }
    
    func requestCode(_ code: String, _ email: String, isManager: Bool) {
        let alert = UIAlertController(title: "Reset Password", message: "Please enter the 8-character code that was sent to the provided email.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "abCD1234"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let enteredCode = textField?.text {
                if enteredCode == "" {
                    self.showResetError(isEmail: false)
                    return
                }
                if (enteredCode == code) {
                    self.passwordChange(email, isManager: isManager)
                } else{
                    self.showResetError(isEmail: false)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func passwordChange(_ email: String, isManager: Bool) {
        let alert = UIAlertController(title: "Reset Password", message: "Please enter the new password.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.isSecureTextEntry = true
            textField.placeholder = "New Password"
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            if let newPassword = textField?.text {
                Firestore.firestore().collection(isManager ? "manager" : "students").document(email).updateData(["password" : newPassword])
                Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
                    if error == nil {
                        do {
                            try Auth.auth().signOut()
                        } catch let e as NSError {
                            print("Error signing out: \(e)")
                        }
                    }
                }
                self.showUpdateSuccess()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUpdateSuccess() {
        let alert = UIAlertController(title: "Reset Password Success", message: "Your password was successfully reset! You may now log into the account normally.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showResetError(isEmail: Bool) {
        let message = isEmail ? "The email you entered could not be found." : "The 8-character code you entered was incorrect."
        
        let alert = UIAlertController(title: "Reset Password Failed", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
                                    
                                    // RESTORE DELETED ACCOUNTS
                                    let alert = UIAlertController(title: "Restore deleted account", message: "This user account has been deleted. Would you like to restore your account?", preferredStyle: .alert)
                                    
                                    alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
                                        self.userData?.updateData(key: "deleted", val: false)
                                        print("Successful login after restoring deleted account")
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        UserDefaults.standard.synchronize()
                                        self.transitionToHome()
                                    }))
                                    
                                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                                    
                                    self.present(alert, animated: true)
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

