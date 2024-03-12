//
//  OddsTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 02/03/2024.
//

import UIKit

class OddsTableCell: UITableViewCell {

    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var awayLabel: UILabel!
    @IBOutlet weak var handicapLabel: UILabel!
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var awayTitleLabel: UILabel!
    @IBOutlet weak var handicapTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(model: OddsInit?, _index: Int) {
        var oddsModel = model?.asia
        switch _index {
        case 0:
            titleLBL.text = "Handicap".localized
            oddsModel = model?.asia
        case 1:
            titleLBL.text = "1X2".localized
            oddsModel = model?.euro
        default:
            titleLBL.text = "Overunder".localized
            oddsModel = model?.bigSmall
        }
        homeTitleLabel.text = "Home".localized
        awayTitleLabel.text = "Away".localized
        handicapTitleLabel.text = _index == 0 ? "Handicap".localized : (_index == 1 ? "Draw".localized : "Goals".localized)
        homeLabel.text = "\(oddsModel?.home ?? 0.0)"
        awayLabel.text = "\(oddsModel?.away ?? 0.0)"
        handicapLabel.text = "\(oddsModel?.handicap ?? 0.0)"
    }
}
