//
//  ProfileEditViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import PhotosUI
import FirebaseAuth

class ProfileEditViewController: UIPhotoDelegate, UITextFieldDelegate {
    // Current User
    var user : User?
    var userData : UserData?
    var delegate : ProfilePageViewController?
    
    // Photo
    @IBOutlet weak var photoView: UIImageView!
    
    // Buttons
    @IBOutlet weak var updatePhotoButton: UIButton!
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // Text Fields
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    
    // Labels
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        if self.user == nil {
            self.user = Auth.auth().currentUser
            if let email = self.user?.email {
                self.userData = UserData(email)
            }
        }
        
        super.viewDidLoad()
        
        errorText.isHidden = true
        photoView.layer.cornerRadius = 3
        
        updatePhotoButton.layer.cornerRadius = 5
        updatePasswordButton.layer.cornerRadius = 5
        deleteButton.layer.cornerRadius = 5
        
        if let userData = self.userData {
            userData.getPhoto() { img, err in
                if let img = img {
                    if img != UIImage(systemName: "person.fill") {
                        self.photoView.image = img
                        self.photoView.contentMode = .scaleAspectFill
                    } else {
                        self.photoView.image = UIImage(systemName: "photo.fill")
                        self.photoView.contentMode = .scaleAspectFit
                    }
                }
            }
        }
                
        oldPassword.delegate = self
        newPassword.delegate = self
        confirmNewPassword.delegate = self
    }
    
    override func didSetPhoto() {
        super.didSetPhoto()
        photoView.image = self.profilePhoto ?? photoView.image
        photoView.image = self.profilePhoto
        photoView.contentMode = .scaleAspectFill
        delegate?.changeProfilePhoto(self.profilePhoto)
        if let userData = self.userData {
            userData.updatePhoto(image: photoView.image!)
        }
    }
    
    // Required by Protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // IB Actions
    @IBAction func updatePhoto(_ sender: UIButton) {
        self.presentPicker()
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        
        let err_index = updatePasswordHelper()
        
        errorText.isHidden = err_index == -1
        
        switch err_index {
        case -1:
            let alert = UIAlertController(title: "Success", message: "Password was successfully updated.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
                self.oldPassword.text = ""
                self.newPassword.text = ""
                self.confirmNewPassword.text = ""
            }))
            self.present(alert, animated: true)
        case 0:
            errorText.text = "You did not fill all fields"
        case 1:
            errorText.text = "Old password is not correct"
        case 2:
            errorText.text = "New password must match confirmation"
        case 3:
            errorText.text = "New password must be at least 6 characters long"
        case 4:
            errorText.text = "New password cannot be the same as old password"
        default:
            errorText.text = "Unknown error. Try again."
        }
    }
    
    // returns a number based on the input error found
    // -1 = no errors found
    // 0 = blank fields
    // 1 = incorrect old password
    // 2 = new password fields do not match
    // 3 = the new password <6 characters in length
    // 4 = the new password is the same as the old one
    func updatePasswordHelper() -> Int {
        let errors = [
            newPassword.text == "" || confirmNewPassword.text == "" || oldPassword.text == "",
            self.userData?.getInfo("password") as? String ?? "" != oldPassword.text,
            self.confirmNewPassword.text != self.newPassword.text,
            self.newPassword.text?.count ?? 0 < 6,
            self.newPassword.text == self.oldPassword.text
        ]
        
        if errors.firstIndex(of: true) == nil {
            self.user?.updatePassword(to: newPassword.text!) { (error) in
                if error == nil {
                    self.userData?.updateData(key: "password", val: self.newPassword.text!)
                }
            }
        }
        
        return errors.firstIndex(of: true) ?? -1
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "DeleteAccount", sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    // Prep for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DeleteAccount" {
            let dest = segue.destination as! DeleteAccountViewController
            dest.user = self.user
            dest.userData = self.userData
        }
    }

}
