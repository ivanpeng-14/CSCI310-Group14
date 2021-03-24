//
//  FilterStudentsTableViewController.swift
//  qrcodeStuff
//
//  Created by Ashley Su on 3/18/21.
//

import UIKit
import Foundation
import FirebaseFirestore

enum selectedScope:Int {
    case building = 0
    case time = 1
    case major = 2
    case id = 3
}

class FilterStudentsTableViewController: UITableViewController, UISearchBarDelegate {
    
//    let students:[Student] =
    var initialStudents = [Student]()
    var students = [Student]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarSetup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x:0,y:0,width:(UIScreen.main.bounds.width),height:70))
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Building","Check In Time","Major", "USC ID"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.autocapitalizationType = UITextAutocapitalizationType.none;
        if searchText.isEmpty {
            students = initialStudents
            self.tableView.reloadData()
        }
        else {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func filterTableView(ind:Int,text:String) {
        switch ind {
            case selectedScope.building.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return student.building.lowercased().contains(text.lowercased())
                })
                self.tableView.reloadData()
            case selectedScope.time.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return student.time.lowercased().contains(text.lowercased())
                })
                self.tableView.reloadData()
            case selectedScope.major.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return student.major.lowercased().contains(text.lowercased())
                })
                self.tableView.reloadData()
            case selectedScope.id.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return String(student.id).contains(text)
                })
                self.tableView.reloadData()
            default:
                print("no type")
        }
    }
    
    
    func getBuildingName(buildingID: String, completion: @escaping (String?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("buildings").document(buildingID).getDocument { (document, error) in
            if let document = document,
                let buildingName = document.get("buildingName"),
                document.exists {
                completion((buildingName as! String), nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        db.collection("students").getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let buildingID = data["currbuilding"] as? String ?? ""
                    if (buildingID != "") {
                        let firstName = data["firstname"] as? String ?? "Anonymous"
                        let lastName = data["lastname"] as? String ?? "Anonymous"
                        let name = firstName + " " + lastName
                        let major = data["major"] as? String ?? "None"
                        let id = (data["uscid"] as! NSString).integerValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                        let time = data["lastcheckin"] as? String ?? dateFormatter.string(from: Date())
                        self.getBuildingName(buildingID: buildingID) { buildingName, error in
                            let newStudent = Student(name: name, major: major, id: id, building:
                                                        buildingName ?? "", time: time)
                            self.initialStudents.append(newStudent)
                            self.students.append(newStudent)
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterStudentsTableViewCell
        
        let student = self.students[indexPath.row]
        
        cell.nameLabel.text = student.name
        cell.majorLabel.text = "(" + student.major + ")"
        cell.idLabel.text = String(student.id)
        cell.buildingLabel.text = student.building
        cell.timeLabel.text = student.time

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
