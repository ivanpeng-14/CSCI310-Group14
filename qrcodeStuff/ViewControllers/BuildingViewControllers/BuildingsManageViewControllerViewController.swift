//
//  BuildingXXXViewController.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit
import FirebaseFirestore

class BuildingsManageViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var numStudentsLabel: UITextField!
    
    var service: BuildingService?
    var allbuildings = [appBuilding]() {
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
        self.modalPresentationStyle = .fullScreen
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
    }
    
    func loadData() {
        service = BuildingService()
              service?.get(collectionID: "buildings") { buildings in
             self.allbuildings = buildings
         }
    }
    
    
}
extension BuildingsManageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buildings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let buildingName = buildings[indexPath.row].buildingName
        let buildingCurrentCapacity = String(buildings[indexPath.row].currentCapacity)
        let buildingTotalCapacity = String(buildings[indexPath.row].totalCapacity)
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuildingCell") as! BuildingManageTableViewCell
        cell.setBuilding(buildingName: buildingName, buildingCurrentCapacity: buildingCurrentCapacity, buildingTotalCapacity: buildingTotalCapacity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Building Info", message: "Choose an option.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Get QR Code", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "QRCodeVC", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Get Building Info", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "buildingInfoVC", sender: self)
        }))
        self.present(alert, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? GenerateQRViewController {
            // destination.modalPresentationStyle = .fullScreen
            let index = tableView.indexPathForSelectedRow?.row
            destination.buildingName = buildings[index!].buildingName
        }
        if let destination2 = segue.destination as? BuildingXXXViewController {
            // destination2.modalPresentationStyle = .fullScreen
            let index = tableView.indexPathForSelectedRow?.row
            destination2.buildingName = buildings[index!].buildingName
            
        }
    }
    
}

