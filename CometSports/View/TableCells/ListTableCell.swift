//
//  ListTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 01/06/2023.
//

import UIKit

class ListTableCell: UITableViewCell {
    
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
