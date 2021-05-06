//
//  DeleteAccountViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

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
        textField.resignFirstResponder()
        return false
    }
    
    // IB Actions
    @IBAction func returnToProfileTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "returnToProfile", sender: self)
    }
    
    
    @IBAction func deleteConfirmed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Account?", message: "Are you sure you want to delete your account? If you choose to delete this account, you may restore it in the future.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {action in
            let passwordCorrect = self.password.text == self.userData?.getInfo("password") as? String ?? ""
            let passwordsMatch = self.password.text == self.confirmPassword.text
            
            if !self.attemptDelete(passwordCorrect, passwordsMatch) {
                let errors = UIAlertController(title: "Error", message: "Could not delete account due to the following error(s):\(passwordCorrect ? "" : "\nIncorrect password entered.")\(passwordsMatch ? "" : "\nPasswords did not match.")", preferredStyle: .alert)
                errors.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {_ in
                    self.password.text = ""
                    self.confirmPassword.text = ""
                }))
                self.present(errors, animated: true)
            } else {
                self.deleteUser()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {_ in
            self.password.text = ""
            self.confirmPassword.text = ""
        }))
        
        self.present(alert, animated: true)
    }
    
    func attemptDelete(_ passwordCorrect: Bool, _ passwordsMatch: Bool) -> Bool {
        let deleteSuccess = passwordCorrect && passwordsMatch
        
        return deleteSuccess
    }
    
    func deleteUser() {
        userData?.updateData(key: "deleted", val: true)
        
        if (userData?.isStudent() ?? false && willCheckOut(userData?.getInfo("currbuilding") as! String)) {
            checkOutUser()
        }
        
        do {
            try Auth.auth().signOut()
            self.returnToLogin()
        } catch let e as NSError {
            print("Error signing out: \(e)")
        }
    }
    
    func willCheckOut(_ currbuilding: String) -> Bool {
        return !(!(userData?.isStudent())! || currbuilding == "")
    }
    
    func checkOutUser() {
        let db = Firestore.firestore()
        let ref = db.collection("buildings").document(self.userData?.getInfo("currbuilding") as? String ?? "")
        db.collection("buildings").document(self.userData?.getInfo("currbuilding") as? String ?? "").getDocument { (document, error) in
            if error == nil {
                let documentData = document!.data()
                let actualName = documentData!["buildingName"] as? String ?? ""
                //update capacity
                let capacity = documentData!["currentCapacity"] as? Int ?? -1
                let newCapacity = capacity - 1
                ref.updateData(["currentCapacity": newCapacity])
                
                //update building history
                ref.updateData(["currentStudents": FieldValue.arrayRemove([self.user?.email ?? ""])])
                
        
                //update students currBuilding
                let studentDoc = db.collection("students").document(self.user?.email ?? "")
                studentDoc.updateData(["currbuilding": ""])
                studentDoc.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked out of \(actualName) at \(Date())"])])
                
            }
        }
    }
    
    func returnToLogin() {
        let loginViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.loginViewController) as! ViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
}
