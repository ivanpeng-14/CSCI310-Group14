//
//  BuildingXXXTableViewCell.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 3/18/21.
//

import UIKit

class BuildingXXXTableViewCell: UITableViewCell {

    @IBOutlet weak var studentNameLabel: UILabel!
    
    @IBOutlet weak var studentIDLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setStudent(studentName: String, studentID: String)
    {
        studentNameLabel.text = studentName
        studentIDLabel.text = studentID
    }

}
