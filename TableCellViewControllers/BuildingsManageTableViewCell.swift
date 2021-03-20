//
//  BuildingXXXTableViewCell.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit

class BuildingXXXTableViewCell: UITableViewCell {

//    @IBOutlet weak var studentNameLabel: UILabel!
//    @IBOutlet weak var studentIDLabel: UILabel!
    @IBOutlet weak var buildingNameLabel: UILabel!
    @IBOutlet weak var buildingCurrentCapacityLabel: UILabel!
    @IBOutlet weak var buildingTotalCapacityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    func setStudent(studentName: String, studentID: String)
//    {
//        studentNameLabel.text = studentName
//        studentIDLabel.text = studentID
//    }
    
    func setBuilding(buildingName: String, buildingCurrentCapacity: String, buildingTotalCapacity: String)
    {
        buildingNameLabel.text = buildingName
        buildingCurrentCapacityLabel.text = buildingCurrentCapacity
        buildingTotalCapacityLabel.text = buildingTotalCapacity
    }

}
