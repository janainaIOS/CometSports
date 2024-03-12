//
//  EventTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 15/07/2023.
//

import UIKit

class EventTableCell: UITableViewCell {

    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellValues(model: EventMatch) {
        homeLBL.text = model.homeName
        awayLBL.text = model.awayName
        dateLBL.text = model.date.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.ddMMyyyy2)
    }
}
