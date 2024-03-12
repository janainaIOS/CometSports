//
//  MatchInfoTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 02/03/2024.
//

import UIKit

class MatchInfoTableCell: UITableViewCell {

    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var valueLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
