//
//  MainPageViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import FirebaseAuth

class ProfilePageViewController: UIViewController {
    
    // Current User
    var user : User?
    var userData : UserData?
    
    // Labels
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var major: UILabel!
    
    // Image Views
    @IBOutlet weak var profilePicture: UIImageView!
    
    // Buttons
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        if let tab = self.tabBarController as? StudentTabBarController {
            self.user = tab.user
            self.userData = tab.userData
        } else if let tab = self.tabBarController as? ManagerTabBarController {
            self.user = tab.user
            self.userData = tab.userData
        } else{
            self.user = Auth.auth().currentUser
            if let email = self.user?.email {
                self.userData = UserData(email)
            }
        }
        
        super.viewDidLoad()
        
        profilePicture.layer.cornerRadius = profilePicture.bounds.width / 2
        
        editButton.layer.cornerRadius = 5
        logOutButton.layer.cornerRadius = 5
        
        if let userData = self.userData {
            let firstName = userData.getInfo("firstname") as! String
            let lastName = userData.getInfo("lastname") as! String
            
            self.fullName.text = firstName + " " + lastName
            self.email.text = user?.email
            
            userData.getPhoto() { img, err in
                self.changeProfilePhoto(img)
            }
            
            if userData.isStudent() {
                self.id.text = userData.getInfo("uscid") as? String ?? "Error Loading"
                self.major.text = userData.getInfo("major") as? String ?? "Error Loading"
            } else {
                self.id.isHidden = true
                self.major.isHidden = true
            }
        }
    }
    
    func changeProfilePhoto(_ img : UIImage?) {
        if let img = img {
            self.profilePicture.image = img
            if img != UIImage(systemName: "person.fill") {
                self.profilePicture.contentMode = .scaleAspectFill
            } else {
                self.profilePicture.contentMode = .scaleAspectFit
            }
        }
    }
    
    @IBAction func editProfilePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EditProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditProfile" {
            let dest = segue.destination as! ProfileEditViewController
            dest.user = self.user
            dest.userData = self.userData
            dest.delegate = self
        }
    }
    
    @IBAction func unwindToProfile(unwindSegue: UIStoryboardSegue) {
    }
}
