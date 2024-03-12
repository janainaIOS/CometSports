//
//  HomeHeaderTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 16/02/2024.
//

import UIKit

class HomeHeaderTableCell: UITableViewCell {

    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var seeAllBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(section: HomeHeaders, tag: Int) {
        titleLBL.text = section.rawValue.localized
        seeAllBTN.isHidden = (section == .topNews || section == .predictions)
        seeAllBTN.setTitle("See all".localized, for: .normal)
        seeAllBTN.tag = tag
    }
}
