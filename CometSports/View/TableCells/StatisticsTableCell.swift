//
//  StatisticsTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 02/03/2024.
//

import UIKit

class StatisticsTableCell: UITableViewCell {

    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var homeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellValues(model: KeyValue) {
        homeLBL.text = model.homeValue
        awayLBL.text = model.awayValue
        titleLBL.text = model.key
        homeWidthConstraint.constant = CGFloat(model.homePercent * 0.01) * (screenWidth - 30)
    }
    
    func setAiScoreMatchCellValues(title: String, homeValue: Int, awayValue: Int) {
        homeLBL.text = "\(homeValue)"
        awayLBL.text = "\(awayValue)"
        titleLBL.text = title.replacingOccurrences(of: "_", with: " ", options: .regularExpression, range: nil).capitalized.localized
        
        let homeValue: CGFloat = CGFloat(homeValue)
        let awayValue: CGFloat = CGFloat(awayValue)
        let totalValue = homeValue + awayValue
        
        if homeValue == 0 && awayValue == 0 {
            homeWidthConstraint.constant = 0.5 * (screenWidth - 20)
            stackView.spacing = 8
        } else {
            let homePercentage: CGFloat = homeValue > 0 ? (homeValue / totalValue) : 0
            homeWidthConstraint.constant = homePercentage * (screenWidth - 20)
            stackView.spacing = (homeValue == 0 || awayValue == 0) ? 0 : 8
        }
    }
}
