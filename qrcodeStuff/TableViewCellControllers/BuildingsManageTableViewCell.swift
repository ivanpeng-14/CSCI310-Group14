//
//  BuildingManageTableViewCell.swift
//  qrcodeStuff
//
//  Created by Claire Jutabha on 3/18/21.
//

import UIKit


class BuildingManageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var buildingCurrentCapacityLabel: UILabel!
    @IBOutlet weak var buildingTotalCapacityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setBuilding(buildingName: String, buildingCurrentCapacity: String, buildingTotalCapacity: String)
    {
        buildingNameLabel.text = buildingName
        buildingCurrentCapacityLabel.text = buildingCurrentCapacity
//        buildingTotalCapacityLabel.text = buildingTotalCapacity
    }
    
    func setBuildingViewForStudents(buildingName: String, buildingCurrentCapacity: String, buildingTotalCapacity: String)
    {
        buildingNameLabel.text = buildingName
        buildingCurrentCapacityLabel.text = buildingCurrentCapacity
        buildingTotalCapacityLabel.text = buildingTotalCapacity
    }

}
