//
//  MainPageViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfilePageViewController: UIViewController {
    
    // Current User
    var user : User?
    var userData : UserData?
    
    // Labels
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var currBuilding: UILabel!
    
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
            let firstName = userData.getInfo("firstname") as? String ?? ""
            let lastName = userData.getInfo("lastname") as? String ?? ""
            
            self.fullName.text = firstName + " " + lastName
            self.email.text = user?.email
            
            userData.getPhoto() { img, err in
                self.changeProfilePhoto(img)
            }
            
            if userData.isStudent() {
                self.id.text = userData.getInfo("uscid") as? String ?? "Error Loading"
                self.major.text = userData.getInfo("major") as? String ?? "Error Loading"
                
                let db = Firestore.firestore()
                db.collection("students").document((Auth.auth().currentUser?.email)!).addSnapshotListener() { doc, err in
                    if let building = doc?.data()?["currbuilding"] as? String {
                        print("got into async")
                        print("building is \(building)")
                        if building != ""{
                            db.collection("buildings").document(building).getDocument() { doc, err in
                                if err == nil {
                                    if let data = doc?.data() {
                                        self.currBuilding.text = "In \(data["buildingName"] as? String ?? "Unknown Building")"
                                    }
                                }
                            }
                        } else {
                            self.currBuilding.text = "Not Checked In"
                        }
                    }
                }
            } else {
                self.id.isHidden = true
                self.major.isHidden = true
                self.currBuilding.isHidden = true
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
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            returnToLogin()
        } catch let e as NSError {
            print("Error signing out: \(e)")
        }
    }
    
    func returnToLogin() {
        let loginViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.loginViewController) as! ViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func unwindToProfile( _ seg: UIStoryboardSegue) {
        let src = seg.source as! DeleteAccountViewController
        self.user = src.user
        self.userData = src.userData
    }
}
