//
//  StudentProfileTwoViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 4/6/21.
//

import UIKit
import FirebaseFirestore

class StudentProfileTwoViewController: UIViewController {
    var studentEmail: String?
    var historyArray: [String] = []
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let db = Firestore.firestore()

        db.collection("students").document(studentEmail!).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    let firstname = documentData!["firstname"] as? String ?? ""
                    let lastname = documentData!["lastname"] as? String ?? ""
                    self.name.text = "\(firstname) \(lastname)"
                    let major = documentData!["major"] as? String ?? ""
                    let id = documentData!["uscid"] as? String ?? ""
                    self.id.text = "ID: \(id)"
                    self.major.text = "Major: \(major)"
                    
                    
                    //table view cell stuff
                    self.historyArray = documentData!["buildingHistory"] as? [String] ?? ["No History"]
                    self.tableView.reloadData()
                    
                }
            }
            else {
                print("error")
            }
        }
    }
    

    

}

extension StudentProfileTwoViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return historyArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = historyArray[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as! StudentHistoryTableViewCell
            cell.setHistory(history: item)
            return cell
        }
       
                
    }
