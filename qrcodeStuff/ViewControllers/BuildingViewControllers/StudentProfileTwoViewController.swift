//
//  StudentProfileTwoViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 4/6/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase

class StudentProfileTwoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var studentEmail: String?
    var historyArray: [String] = []
    var initialHistory: [String] = []
    var buildingID: String?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTime: UIDatePicker!
    @IBOutlet weak var searchButton: UIButton!
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
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
    
    @IBAction func kickOutButton(_ sender: Any) {
        let db = Firestore.firestore()

        db.collection("students").document(studentEmail!).getDocument { (document, error) in
            if error == nil {
                //check if document exists
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    let studentBuilding = documentData!["currbuilding"] as? String ?? ""
                    //
                    
                    if studentBuilding == "" || self.buildingID != studentBuilding
                    {
                        let alert = UIAlertController(title: "Error", message: "Student is not checked in to this building anymore.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                            self.viewDidLoad()
                        }))
                        self.present(alert, animated: true)
                    
                    }
                    else {
                        let alert = UIAlertController(title: "Kick Out", message: "Kick this student out?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                            self.viewDidLoad()
                        }))
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                            let ref = db.collection("buildings").document(studentBuilding)
                            ref.updateData(["currentStudents" : FieldValue.arrayRemove([self.studentEmail!])])
                            let alert2 = UIAlertController(title: "Success", message: "", preferredStyle: .alert)
                            alert2.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                                db.collection("buildings").document(studentBuilding).getDocument { (document, error) in
                                    if error == nil {
                                        let ref = db.collection("buildings").document(studentBuilding)
                                        let documentData = document!.data()
                                        let actualName = documentData!["buildingName"] as? String ?? ""
                                        //update capacity
                                        let capacity = documentData!["currentCapacity"] as? Int ?? -1
                                        let newCapacity = capacity - 1
                                        ref.updateData(["currentCapacity": newCapacity])
                                        
                                        //update students currBuilding
                                        let studentDoc = db.collection("students").document(self.studentEmail!)
                                        studentDoc.updateData(["currbuilding": ""])
                                        //update student history
                                        let studentHistory = db.collection("students").document(self.studentEmail!)
                                        studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked out of \(actualName) at \(Date())"])])
                                        //update kickOut in student
                                        studentHistory.updateData(["kickOut": actualName])
                                        
                                        
                                    }
                                }
                                self.viewDidLoad()
                            }))
                            self.present(alert2, animated: true)
                        }))
                        self.present(alert, animated: true)
                   }
                }
            }
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        timeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        timeSwitch.addTarget(self, action: #selector(self.switchChanged), for: UIControl.Event.valueChanged)
        fromTime.datePickerMode = .dateAndTime
        toTime.datePickerMode = .dateAndTime
        let timeZone = TimeZone.init(identifier: "UTC")
        guard let newTimeZone = timeZone else {return}
        fromTime.timeZone = newTimeZone
        toTime.timeZone = newTimeZone
        loadData()
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let ref = storage.reference()

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

                    //get profile pic
                    let pic = documentData!["photo"] as? String ?? ""
                    print(pic)
                    let imageRef = ref.child(pic)
                    imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                      if error == nil {
                        self.profilePic.image = UIImage(data: data!)
                      } else {
                        print("picture error")
                      }
                    }
                    
                    //table view cell stuff
                    self.historyArray = documentData!["buildingHistory"] as? [String] ?? ["No History"]
                    self.initialHistory = documentData!["buildingHistory"] as? [String] ?? ["No History"]
                    self.tableView.reloadData()
                }
            }
            else {
                print("error")
            }
        }
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
        return buildings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return buildings[row].buildingName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        buildingTextField.text = buildings[row].buildingName
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
        currentTextField = textField
        currentTextField.inputView = pickerView
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        currentTextField.inputAccessoryView = toolBar
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @objc func action() {
          view.endEditing(true)
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        let building = buildingTextField.text ?? ""
        // format time
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        self.historyArray = self.initialHistory.filter({ (item) -> Bool in
            var buildingName = ""
            var buildingTime = ""
            
            if item.contains("into") { // check in
                // Checked into [building_name] at 0000-00-00 00:00:00 +0000
                // buildingName = [building_name] and buildingTime = 0000-00-00 00:00:00 +0000
                let pattern = "Checked into (.*) at ([0-9\\- :+]+)"
                do {
                    let regex = try NSRegularExpression(pattern: pattern)
                    if let match = regex.firstMatch(in: item, range: NSRange(item.startIndex..., in: item)) {
                        buildingName = String(item[Range(match.range(at: 1), in: item)!])
                        buildingTime = String(item[Range(match.range(at: 2), in: item)!])
                    }
                } catch { print(error) }
            }
            else { // check out
                let pattern = "Checked out of (.*) at ([0-9\\- :+]+)"
                do {
                    let regex = try NSRegularExpression(pattern: pattern)
                    if let match = regex.firstMatch(in: item, range: NSRange(item.startIndex..., in: item)) {
                        buildingName = String(item[Range(match.range(at: 1), in: item)!])
                        buildingTime = String(item[Range(match.range(at: 2), in: item)!])
                    }
                } catch { print(error) }
            }
            
            var filtered = true
            if (building != "") {
                filtered = filtered && buildingName.lowercased().contains(building.lowercased())
            }
            timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let time = buildingTime
            let date = timeFormatter.date(from:time)
            if fromTime.date > toTime.date {
                fromTime.date = toTime.date
            }
            let range = fromTime.date...toTime.date
            filtered = filtered && range.contains(date ?? Date())
            
            return filtered
        })
        
        self.tableView.reloadData()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        buildingTextField.text = ""
        timeSwitch.setOn(false, animated: false)
        switchChanged(mySwitch:timeSwitch)
        searchButtonTapped((Any).self)
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
