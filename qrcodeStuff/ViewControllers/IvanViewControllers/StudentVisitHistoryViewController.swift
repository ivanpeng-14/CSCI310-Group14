//
//  BuildingXXXViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class StudentVisitHistoryViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numStudentsLabel: UITextField!
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTime: UIDatePicker!
    @IBOutlet weak var timeSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    @IBAction func checkoutButton(_ sender: Any) {
        let userID = userEmail
        print(userID)
        let db = Firestore.firestore()
        db.collection("students").document(userID).getDocument { (document, error) in
            if error == nil {
                let studentBuildingName = document!.data()!["currbuilding"] as? String ?? ""
            
                if (studentBuildingName == "")
                {
                    let alert = UIAlertController(title: "Check Out", message: "You are not checked to any building.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
                        self.viewDidLoad()
                    }))
                    self.present(alert, animated: true)
                }
                else
                {
                    let alert = UIAlertController(title: "Check Out", message: "Check out of building?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                        self.viewDidLoad()
                    }))
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        let ref = db.collection("buildings").document(studentBuildingName)
                        
                        ref.updateData(["currentStudents" : FieldValue.arrayRemove([userID])])
                        sleep(3)
                        
                        db.collection("buildings").document(studentBuildingName).getDocument { (document, error) in
                            if error == nil {
                                let documentData = document!.data()
                                let actualName = documentData!["buildingName"] as? String ?? ""
                                //update capacity
                                let capacity = documentData!["currentCapacity"] as? Int ?? -1
                                let newCapacity = capacity - 1
                                ref.updateData(["currentCapacity": newCapacity])
                                
            
                        
                                //update students currBuilding
                                let studentDoc = db.collection("students").document(userID)
                                studentDoc.updateData(["currbuilding": ""])
                                //update student history
                                let studentHistory = db.collection("students").document(userID)
                                studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked out of \(actualName) at \(Date())"])])
                                
                            }
                        }
                    }))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
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
    
    let user = Auth.auth().currentUser
    var userEmail = ""
    var studentVisitHistory = [[String]]()
    var tempBuildingHistory = [String]()
    var initialBuildingHistory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        tableView.dataSource = self
        tableView.delegate = self
        timeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        timeSwitch.addTarget(self, action: #selector(self.switchChanged), for: UIControl.Event.valueChanged)
        fromTime.datePickerMode = .dateAndTime
        toTime.datePickerMode = .dateAndTime
        let timeZone = TimeZone.init(identifier: "UTC")
        guard let newTimeZone = timeZone else {return}
        fromTime.timeZone = newTimeZone
        toTime.timeZone = newTimeZone
        loadData()
//        displayUserData()
    }
    
    func loadData() {
//        let db = Firestore.firestore()
        service = BuildingService()
              service?.get(collectionID: "buildings") { buildings in
             self.allbuildings = buildings
         }
        setUserEmail()
        setBuildingData()
    }
    
    func setUserEmail() {
        if let emailWrapped = user?.email {
            userEmail = emailWrapped
            print(userEmail)
            
        }
    }
    
    func setBuildingData() {
        let db = Firestore.firestore()
//        var buildingHistory: [String] = []
        
        // Grabbing buildingHistory data
        db.collection("students").document(userEmail).addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
//              print("Current data: \(data)")
            self.tempBuildingHistory = data["buildingHistory"] as? [String] ?? []
            self.initialBuildingHistory = data["buildingHistory"] as? [String] ?? []
            self.tempBuildingHistory.reverse()
            self.initialBuildingHistory.reverse()
            print("buildingHistory: \(self.tempBuildingHistory)")
            
        }
    }
    
    @IBAction func checkInTapped(_ sender: Any) {
        let db = Firestore.firestore()
        let studentHistory = db.collection("students").document(userEmail)
        studentHistory.updateData(["buildingHistory": FieldValue.arrayUnion(["Checked into SGM106 at \(Date())"])])
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
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.tempBuildingHistory = self.initialBuildingHistory.filter({ (item) -> Bool in
            var buildingName = ""
            var buildingTime = ""
            if item.contains("into") { // check in
                let list = item.split(separator: " ")
                buildingName = String(list[2] + " " + list[3] + " " + list[4])
                buildingTime = String(list[6] + " " + list[7])
            }
            else { // check out
                let list = item.split(separator: " ")
                buildingName = String(list[3] + " " + list[4] + " " + list[5])
                buildingTime = String(list[7] + " " + list[8])
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

extension StudentVisitHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempBuildingHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var buildingName = ""
        var buildingTime = ""
        var checkIn = false
        
        if tempBuildingHistory[indexPath.row].contains("into") { // check in
            
            let list = tempBuildingHistory[indexPath.row].split(separator: " ")
            print(list)
            buildingName = String(list[2] + " " + list[3] + " " + list[4])
            buildingTime = String(list[6] + ", " + list[7])
            checkIn = true
        }
        else { // check out
            
            let list = tempBuildingHistory[indexPath.row].split(separator: " ")
            print(list)
            buildingName = String(list[3] + " " + list[4] + " " + list[5])
            buildingTime = String(list[7] + ", " + list[8])
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as! BuildingManageTableViewCell
        cell.setBuildingViewFeed(buildingName: buildingName, lastCheckInTime: buildingTime, checkIn: checkIn)
        return cell
    }
    
}

