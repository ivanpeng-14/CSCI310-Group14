//
//  MainPageViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
class ProfilePageViewController: UIViewController {
    
    func notify() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert]) { (granted, error) in
           
        }
        let content = UNMutableNotificationContent()
        content.title = "You got kicked out of the building!"
        content.body = ""
        
        let date = Date().addingTimeInterval(5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            
        }
    }
    
    
    
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
                getNotifications()
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
    
    func getNotifications() {
        let db = Firestore.firestore()
        db.collection("students").document(self.email.text!).addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            guard let data = document.data() else {
              print("Document data was empty.")
              return
            }
            
            let kickOut = data["kickOut"] as? String ?? ""
            if kickOut == ""
            {
                
            }
            else
            {
                let alert = UIAlertController(title: "You've been kicked out of \(kickOut)", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                    // change kick out back to null
                    let ref = db.collection("students").document(self.email.text!)
                    ref.updateData(["kickOut": ""])
                    self.viewDidLoad()
                }))
                self.present(alert, animated: true)
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
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                print("User is not logged in anymore!")
                self.returnToLogin()
            } catch let e as NSError {
                print("Error signing out: \(e)")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
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
