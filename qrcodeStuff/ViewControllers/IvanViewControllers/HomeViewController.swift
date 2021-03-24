//
//  HomeViewController.swift
//  login2
//
//  Created by Ivan Peng on 3/21/21.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

// Welcome screen after successful login/signup
class HomeViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var userEmail = ""
    var userIsManager = false;
    var userData : UserData?

    override func viewDidLoad() {
        if let email = self.user?.email {
            userEmail = email
            self.userData = UserData(email)
        }
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        print("userIsManager is " + String(userIsManager))
//        displayUserData()
    }
    
    func loadData() {
//        let db = Firestore.firestore()
        
    }
    
    
    func setUserIsManager() {
        let db = Firestore.firestore()
        if userEmail != "" {
            // search database for user and check if user is manager
            db.collection("manager").document(userEmail).getDocument { (document, error) in
                if let document = document, document.exists {
                    self.userIsManager =  true;
                }
            }
            
        }
    }
    
    @IBAction func returnTapped(_ sender: Any) {
        self.transitionToLogin()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        if (!(userData?.isStudent())!) {
            print("transitioning to manager view");
            self.transitionToManagerView();
        } else{
            print("transitioning to student view");
            self.transitionToStudentView();
        }
    }
    
    
    @IBAction func goToManagerFeed(_ sender: Any) {
        print("going to manager feed")
            self.transitionToManagerFeed()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func transitionToStudentView() {
        
        let studentTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.studentTabController) as! StudentTabBarController
        
        studentTabController.user = self.user
        studentTabController.userData = self.userData
        
        view.window?.rootViewController = studentTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToManagerView() {
        
        let managerTabController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.managerTabController) as! ManagerTabBarController
        
        managerTabController.user = self.user
        managerTabController.userData = self.userData
        
        view.window?.rootViewController = managerTabController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToLogin() {
        
        let loginViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.loginViewController) as? ViewController

        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToStudentVisitHistory() {
        
        let studentViewHistoryViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.studentVisitHistoryViewController) as? StudentVisitHistoryViewController

        view.window?.rootViewController = studentViewHistoryViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToManagerFeed() {
        
        let managerFeedViewController = storyboard?.instantiateViewController(identifier:  Constants.Storyboard.managerFeedViewController) as? ManagerFeedViewController

        view.window?.rootViewController = managerFeedViewController
        view.window?.makeKeyAndVisible()
        
    }
}
