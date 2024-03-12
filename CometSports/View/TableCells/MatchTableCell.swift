//
//  MatchTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 30/05/2023.
//

import UIKit

class MatchTableCell: UITableViewCell {

    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var resultLBL: UILabel!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var vsLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func setCellValues(model: Matches) {
        leagueLBL.text = model.league
        resultLBL.text = " \(model.matchState.getMatchState()) "
        homeLBL.text = model.homeName
        awayLBL.text = model.awayName
        scoreLBL.text = ""
        if model.homeScore != "" && model.awayScore != "" {
            scoreLBL.text = "\(model.homeScore) - \(model.awayScore)"
        }
        vsLBL.text = "vs".localized
    }
   
}


