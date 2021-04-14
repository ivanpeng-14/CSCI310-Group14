//
//  ViewController.swift
//  Trojan Check In
//
//  Created by Carlos Lao on 2021/3/21.
//

import UIKit
import PhotosUI
import FirebaseAuth

class PhotoUploadViewController: UIPhotoDelegate {
    
    var user : User?
    var userData : UserData?
    
    let defaultImage = UIImage(systemName: "photo.fill")
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        self.user = Auth.auth().currentUser
        let email = self.user!.email
        self.userData = UserData(email!)
        
        super.viewDidLoad()
        
        photoView.layer.cornerRadius = 3
        createAccountButton.layer.cornerRadius = 5
    }
    
    override func didSetPhoto() {
        super.didSetPhoto()
        photoView.image = self.profilePhoto ?? photoView.image
        photoView.image = self.profilePhoto
        photoView.contentMode = .scaleAspectFill
        userData!.updatePhoto(image: photoView.image!)
    }
    
    // IB Actions
    @IBAction func photoIconTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Upload Photo", message: "Upload photo from..", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
            self.presentPicker()
        }))
        alert.addAction(UIAlertAction(title: "URL", style: .default, handler: { _ in
            self.photoFromURL()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        if userData!.isStudent() {
            transitionToStudent()
        } else{
            transitionToManager()
        }
    }
    
    func transitionToStudent() {
        
        let studentTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.studentTabController) as! StudentTabBarController
        
        studentTabController.user = self.user
        studentTabController.userData = self.userData
        
        view.window?.rootViewController = studentTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToManager() {
        
        let managerTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.managerTabController) as! ManagerTabBarController
        
        managerTabController.user = self.user
        managerTabController.userData = self.userData
        
        view.window?.rootViewController = managerTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateStudent" {
            let dest = segue.destination as! StudentTabBarController
            dest.user = self.user
            dest.userData = self.userData
        } else {
            let dest = segue.destination as! ManagerTabBarController
            dest.user = self.user
            dest.userData = self.userData
        }
    }
}

