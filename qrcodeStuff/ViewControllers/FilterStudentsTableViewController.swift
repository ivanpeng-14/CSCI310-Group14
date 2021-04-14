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
    var emailArray: [String] = []
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
        loadData()
        nameTextField.delegate = self
        idTextField.delegate = self
    }
    
    func loadData() {
        service = BuildingService()
        service?.get(collectionID: "buildings") { buildings in
            self.allbuildings = buildings
        }
        
        let db = Firestore.firestore()
        self.emailArray.removeAll()
        self.students.removeAll()
        self.initialStudents.removeAll()
        self.tableView.reloadData()
        db.collection("students").getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            }
            else {
                // iterate over students
                for document in (snapshot?.documents)! {
                    let data = document.data()
                    let deleted = data["deleted"] as? Bool ?? true
                    if (!deleted) {
                        let firstName = data["firstname"] as? String ?? "Anonymous"
                        let lastName = data["lastname"] as? String ?? "Anonymous"
                        let name = firstName + " " + lastName
                        let email = data["email"] as? String ?? ""
                        let major = data["major"] as? String ?? "None"
                        let id = (data["uscid"] as! NSString).integerValue
                        let checkIns = data["buildingHistory"] as? [String] ?? []
                        for checkIn in checkIns {
                            if checkIn.contains("into") { // check in
                                let pattern = "Checked into (.*) at ([0-9\\- :+]+)"
                                do {
                                    let regex = try NSRegularExpression(pattern: pattern)
                                    if let match = regex.firstMatch(in: checkIn, range: NSRange(checkIn.startIndex..., in: checkIn)) {
                                        let buildingName = String(checkIn[Range(match.range(at: 1), in: checkIn)!])
                                        let time = String(checkIn[Range(match.range(at: 2), in: checkIn)!])
                                        let newStudent = Student(name: name, lastName:lastName, email:email, major: major, id: id, building: buildingName, time: time)
                                        self.emailArray.append(email)
                                        self.initialStudents.append(newStudent)
                                        self.students.append(newStudent)
                                    }
                                } catch { print(error) }
                            }
                        } // end for checkIn loop
                    } // end if !deleted
                } // end document loop
                
                self.tableView.reloadData()
            }
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
            let time = student.time
            let date = timeFormatter.date(from:time)
            if fromTime.date > toTime.date {
                fromTime.date = toTime.date
            }
            let range = fromTime.date...toTime.date
            filtered = filtered && range.contains(date ?? Date())
            
            return filtered
        })
    
        self.students.sort(by: {$0.lastName.caseInsensitiveCompare($1.lastName) == .orderedAscending})
        self.emailArray.removeAll()
        for student in self.students {
            self.emailArray.append(student.email)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        majorTextField.text = ""
        buildingTextField.text = ""
        nameTextField.text = ""
        idTextField.text = ""
        searchButtonTapped((Any).self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "View Student Profile?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "studentSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? StudentProfileTwoViewController {
            // destination.modalPresentationStyle = .fullScreen
            let index = tableView.indexPathForSelectedRow?.row
            destination.studentEmail = emailArray[index!]
        }
        
    }

}
