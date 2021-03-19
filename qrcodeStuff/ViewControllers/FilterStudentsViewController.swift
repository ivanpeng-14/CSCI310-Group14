//
//  FilterStudentsViewController.swift
//  qrcodeStuff
//
//  Created by Ashley Su on 3/16/21.
//

import UIKit
import FirebaseFirestore

class FilterStudentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var data = [String]()
    var filteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    
    
    private func setupData() {
        let db = Firestore.firestore()
        db.collection("students").addDocument(data: ["name":"Ashley", "email":"suashley@usc.edu", "building_id":1])
        data.append("John")
        data.append("Abe")
        data.append("Jenny")
        data.append("Dan")
        data.append("Luke")
        data.append("Zach")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredData.isEmpty {
            return filteredData.count
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if !filteredData.isEmpty {
            cell.textLabel?.text = filteredData[indexPath.row]
        }
        else {
            cell.textLabel?.text = data[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

