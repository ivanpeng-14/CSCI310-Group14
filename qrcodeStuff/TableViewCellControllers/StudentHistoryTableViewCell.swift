//
//  StudentHistoryTableViewCell.swift
//  qrcodeStuff
//
//  Created by Jenny Hu on 4/6/21.
//

import UIKit

class StudentHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setHistory(history:String)
    {
        item.text = history;
    }

}
