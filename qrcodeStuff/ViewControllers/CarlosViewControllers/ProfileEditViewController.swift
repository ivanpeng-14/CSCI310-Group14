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
    
    
    override func viewDidLoad() {
        if self.user == nil {
            self.user = Auth.auth().currentUser
            if let email = self.user?.email {
                self.userData = UserData(email)
            }
        }
        
        super.viewDidLoad()
        
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
        userData!.updatePhoto(image: photoView.image!)
    }
    
    // Required by Protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return textField.text != ""
    }
    
    // IB Actions
    @IBAction func updatePhoto(_ sender: UIButton) {
        self.presentPicker()
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        if newPassword != nil && newPassword.text == confirmNewPassword.text {
            self.user?.updatePassword(to: newPassword.text!) { (error) in
                if error != nil {
                    print("An error occured while updating the password")
                }
            }
        }
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "DeleteAccount", sender: self)
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
