//
//  LineupTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 19/07/2023.
//

import UIKit

class LineupTableCell: UITableViewCell {
    
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var ageLBL: UILabel!
    @IBOutlet weak var numLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValues(dataArray: [String]) {
        if dataArray.indices.contains(0) {
            numLBL.text = dataArray[0]
        }
        if dataArray.indices.contains(2) {
            userImageIV.setImage(imageStr: dataArray[2], placeholder: UIImage(named: "user2"))
        }
        if dataArray.indices.contains(3) {
            userNameLBL.text = dataArray[3]
        }
        if dataArray.indices.contains(5) {
            ageLBL.text = "Age: \(dataArray[5])"
        }
    }
}
