//
//  LanguageTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 03/06/2023.
//

import UIKit

class LanguageTableCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconBgView: UIView!
    @IBOutlet weak var titleLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellValues(selected: Bool, title: String) {
        titleLBL.text = title
        bgView.backgroundColor = selected ? .gray2 : .black
        iconBgView.backgroundColor = selected ? .base2Color : .clear
        bgView.alpha = selected ? 1.0 : 0.6
    }
}
