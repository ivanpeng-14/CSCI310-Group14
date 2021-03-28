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
        let allFieldsEntered = newPassword.text != "" && confirmNewPassword.text != "" && oldPassword.text != ""
        let oldPasswordCorrect = self.userData?.getInfo("password") as? String == oldPassword.text
        let newPasswordMatch = self.confirmNewPassword.text == self.newPassword.text
        let newPasswordLong = self.newPassword.text?.count ?? 0 >= 6
        let newPasswordNew = self.newPassword.text != self.oldPassword.text
        
        if allFieldsEntered && oldPasswordCorrect && newPasswordMatch && newPasswordLong && newPasswordNew {
            errorText.isHidden = true
            
            self.user?.updatePassword(to: newPassword.text!) { (error) in
                let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: { _ in
                    self.oldPassword.text = ""
                    self.newPassword.text = ""
                    self.confirmNewPassword.text = ""
                })
                
                if error != nil {
                    let alert = UIAlertController(title: "Uh oh!", message: "An unknown error occured. Your password could not be updated", preferredStyle: .alert)
                    alert.addAction(dismiss)
                    print("An error occured while updating the password")
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Success", message: "Password was successfully updated.", preferredStyle: .alert)
                    alert.addAction(dismiss)
                    self.userData?.updateData(key: "password", val: self.newPassword.text!)
                    self.present(alert, animated: true)
                }
            }
        } else {
            errorText.isHidden = false
            if !allFieldsEntered {
                errorText.text = "You did not fill all fields"
            } else if !oldPasswordCorrect {
                errorText.text = "Old password is not correct"
            } else if !newPasswordMatch {
                errorText.text = "New password must match confirmation"
            } else if !newPasswordLong {
                errorText.text = "New password must be at least 6 characters long"
            } else {
                errorText.text = "New password cannot be the same as old password"

            }
        }
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
