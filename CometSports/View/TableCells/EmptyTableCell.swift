//
//  EmptyTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 19/02/2024.
//

import UIKit

class EmptyTableCell: UITableViewCell {

    @IBOutlet weak var titleLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
