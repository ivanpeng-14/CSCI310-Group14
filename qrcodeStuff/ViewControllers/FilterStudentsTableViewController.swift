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
    case major = 1
    case id = 2
    case name = 3
}

class FilterStudentsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTime: UIDatePicker!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    var initialStudents = [Student]()
    var students = [Student]()
    var majorList = [
        "Aerospace Engineering",
        "Mechanical Engineering",
        "Astronautical Engineering",
        "Biomedical Engineering",
        "Chemical Engineering",
        "Civil Engineering",
        "Environmental Engineering",
        "Computer Science",
        "Computer Science and Business Administration",
        "Electrical Engineering",
        "Computer Engineering",
        "Industrial and Systems Engineering"
    ]
    
    private var service: BuildingService?
    private var allbuildings = [appBuilding]() {
        didSet {
            DispatchQueue.main.async {
                self.buildings = self.allbuildings
            }
        }
    }
    
    var buildings = [appBuilding]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        timeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        timeSwitch.addTarget(self, action: #selector(self.switchChanged), for: UIControl.Event.valueChanged)
        fromTime.datePickerMode = .dateAndTime
        toTime.datePickerMode = .dateAndTime
        let timeZone = TimeZone.init(identifier: "UTC")
        guard let newTimeZone = timeZone else {return}
        fromTime.timeZone = newTimeZone
        toTime.timeZone = newTimeZone
//        fromTime.timezone = TimeZone.init(identifier: "UTC")
//        toTime.timezone = TimeZone.init(identifier: "UTC")
        loadData()
        nameTextField.delegate = self
        idTextField.delegate = self
    }
    
    
    func loadData() {
        service = BuildingService()
        service?.get(collectionID: "buildings") { buildings in
            self.allbuildings = buildings
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (currentTextField == majorTextField) {
            sortMajors()
            return majorList.count
        } else if (currentTextField == buildingTextField) {
            return buildings.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (currentTextField == majorTextField) {
            return majorList[row]
        } else if (currentTextField == buildingTextField) {
            return buildings[row].buildingName
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (currentTextField == majorTextField) {
            majorTextField.text = majorList[row] // selected item
        } else if (currentTextField == buildingTextField) {
            buildingTextField.text = buildings[row].buildingName // selected item
        }
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        if timeSwitch.isOn {
            fromTime.isUserInteractionEnabled = true
            toTime.isUserInteractionEnabled = true
            fromTime.alpha = 1
            toTime.alpha = 1
            fromTime.date = Date()
            toTime.date = Date()
        } else {
            fromTime.isUserInteractionEnabled = false
            toTime.isUserInteractionEnabled = false
            fromTime.date = Date.distantPast
            toTime.date = Date.distantFuture
            fromTime.alpha = 0
            toTime.alpha = 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        if (textField == majorTextField || textField == buildingTextField) {
            currentTextField = textField
            currentTextField.inputView = pickerView
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            currentTextField.inputAccessoryView = toolBar
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == majorTextField || textField == buildingTextField) {
            return false
        }
        else {
            return true
        }
    }
    
    @objc func action() {
          view.endEditing(true)
    }
    
    func sortMajors() {
        majorList.sort()
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let id = idTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let major = majorTextField.text ?? ""
        let building = buildingTextField.text ?? ""
        // format time
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let from = timeFormatter.string(from: fromTime.date)
        let to = timeFormatter.string(from: toTime.date)
        self.students = self.initialStudents.filter({ (student) -> Bool in
            var filtered = true
            if (name != "") {
                filtered = student.name.lowercased().contains(name.lowercased())
            }
            if (building != "") {
                filtered = filtered && student.building.lowercased().contains(building.lowercased())
            }
            if (major != "") {
                filtered = filtered && student.major.lowercased().contains(major.lowercased())
            }
            if (id != "") {
                filtered = filtered && String(student.id).contains(id)
            }
            timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let time = student.time ?? ""
            let date = timeFormatter.date(from:time)
            let range = fromTime.date...toTime.date
            filtered = filtered && range.contains(date ?? Date())
            
            return filtered
        })
    
        self.students.sort(by: {$0.lastName.caseInsensitiveCompare($1.lastName) == .orderedAscending})
        self.tableView.reloadData()
    }
    
    func filterTableView(ind:Int,text:String,initialStudents:[Student]) -> [Student] {
        var students = [Student]()
        switch ind {
            case selectedScope.building.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return student.building.lowercased().contains(text.lowercased())
                })
//            case selectedScope.time.rawValue:
//                students = initialStudents.filter({ (student) -> Bool in
//                    return student.time.lowercased().contains(text.lowercased())
//                })
            case selectedScope.major.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return student.major.lowercased().contains(text.lowercased())
                })
            case selectedScope.id.rawValue:
                students = initialStudents.filter({ (student) -> Bool in
                    return String(student.id).contains(text)
                })
            default:
                print("no type")
        }
        return students
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        majorTextField.text = ""
        buildingTextField.text = ""
        nameTextField.text = ""
        idTextField.text = ""
        searchButtonTapped((Any).self)
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
            self.students = self.initialStudents
            self.tableView.reloadData()
        }
        else {
            self.students = filterTableView(ind: searchBar.selectedScopeButtonIndex, text:searchText, initialStudents:self.initialStudents)
            self.tableView.reloadData()
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
                    let deleted = data["deleted"] as? Bool ?? true
                    if (buildingID != "" && !deleted) {
                        let firstName = data["firstname"] as? String ?? "Anonymous"
                        let lastName = data["lastname"] as? String ?? "Anonymous"
                        let name = firstName + " " + lastName
                        let major = data["major"] as? String ?? "None"
                        let id = (data["uscid"] as! NSString).integerValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                        let time = data["lastcheckin"] as? String ?? dateFormatter.string(from: Date())
                        self.getBuildingName(buildingID: buildingID) { buildingName, error in
                            let newStudent = Student(name: name, lastName:lastName, major: major, id: id, building:
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.students = [Student]()
        self.initialStudents = [Student]()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.students.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
