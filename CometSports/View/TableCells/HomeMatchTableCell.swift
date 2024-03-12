//
//  HomeMatchTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 08/07/2023.
//

import UIKit

class HomeMatchTableCell: UITableViewCell {

    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var statusLBL: UILabel!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
