//
//  MatchH2HTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 02/03/2024.
//

import UIKit

class MatchH2HTableCell: UITableViewCell {

    @IBOutlet weak var leagueImageView: UIImageView!
    @IBOutlet weak var leagueNameLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var overtimeLabel: UILabel!
    @IBOutlet weak var halftimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: MatchInfo) {
        homeNameLabel.text = model.homeName
        awayNameLabel.text = model.awayName
        overtimeLabel.text = "Overtime".localized + ":" + "\(model.homeOvertimeScore ?? 0)-\(model.awayOvertimeScore ?? 0)"
        halftimeLabel.text = "Ranking".localized + ":" + "\(model.homeRanking ?? "" )-\(model.awayRanking ?? "")"
        scoreLabel.text = "\(model.homeScore ?? 0) - \(model.awayScore ?? 0)"
    }
}
