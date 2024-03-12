//
//  MatchesTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 15/02/2024.
//

import UIKit

class MatchesTableCell: UITableViewCell {
    
    @IBOutlet weak var leagueIV: UIImageView!
    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var vsLBL: UILabel!
    @IBOutlet weak var homeImageIV: UIImageView!
    @IBOutlet weak var awayImageIV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCellValues(model: MatchList) {
        leagueIV.setImage(imageStr: model.leagueInfo.logo, placeholder: Images.league)
        leagueLBL.text = selectedLang == .en ? model.leagueInfo.enName : model.leagueInfo.cnName
        homeLBL.text = selectedLang == .en ? model.homeInfo.enName : model.homeInfo.cnName
        awayLBL.text = selectedLang == .en ? model.awayInfo.enName : model.awayInfo.cnName
        scoreLBL.text = ""
        let homeScore = String(model.homeInfo.homeScore)
        let awayScore = String(model.awayInfo.awayScore)
        if homeScore != "" && awayScore != "" {
            scoreLBL.text = "\(homeScore) - \(awayScore)"
        }
        vsLBL.text = "vs".localized
        homeImageIV.setImage(imageStr: model.homeInfo.logo, placeholder: Images.league)
        awayImageIV.setImage(imageStr: model.awayInfo.logo, placeholder: Images.league)
    }
}
