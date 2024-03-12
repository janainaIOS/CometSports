//
//  PredictionTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 15/02/2024.
//

import UIKit

class PredictionTableCell: UITableViewCell {

    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var winRateLBL: UILabel!
    @IBOutlet weak var winRateTitleLBL: UILabel!
    @IBOutlet weak var winStreakLBL: UILabel!
    @IBOutlet weak var winStreakTitleLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var leagueImageIV: UIImageView!
    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var homeImageIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayImageIV: UIImageView!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var subTitleLBL: UILabel!
    @IBOutlet weak var typeLBL: UILabel!
    @IBOutlet weak var predictionTimeLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(model: Prediction) {
        userImageIV.setImage(imageStr: model.reddragonUser?.profileImg ?? "", placeholder: Images.user)
        userNameLBL.text = model.reddragonUser?.fullName?.capitalized ?? "Unknown".localized
        winRateLBL.text = "\(model.reddragonUser?.predictionSuccessRate ?? 0)%"
        winRateTitleLBL.text = "Win Rate".localized
        let predStreak = model.predictionStreak?.replacingOccurrences(of: ",", with: "")
        winStreakLBL.text = "\(predStreak?.count ?? 0)"
        winStreakTitleLBL.text = "Win Streak".localized
        titleLBL.text = model.title
        leagueImageIV.setImage(imageStr: model.match?.competetionDetails?.logo ?? "", placeholder: Images.league)
        leagueLBL.text = selectedLang == .en ? model.match?.competetionDetails?.name : model.match?.competetionDetails?.nameZhn
        homeImageIV.setImage(imageStr: model.match?.homeTeamDetail?.logo ?? "", placeholder: Images.league)
        awayImageIV.setImage(imageStr: model.match?.awayTeamDetail?.logo ?? "", placeholder: Images.league)
        homeLBL.text = selectedLang == .en ? model.match?.homeTeamDetail?.name : model.match?.homeTeamDetail?.nameZhn
        awayLBL.text = selectedLang == .en ? model.match?.awayTeamDetail?.name : model.match?.awayTeamDetail?.nameZhn
        dateLBL.text = model.match?.matchTime?.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssa, outputFormat: dateFormat.ddMMyyyy2)
        timeLBL.text = model.match?.matchTime?.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssa, outputFormat: dateFormat.Hmma)
        scoreLBL.text = "\(model.match?.homeScores?.score ?? 0) : \(model.match?.awayScores?.score ?? 0)"
        subTitleLBL.text = model.comments
        predictionTimeLBL.text = model.createdAt?.formatDate2(inputFormat: dateFormat.yyyyMMddHHmmssTimeZone)
        typeLBL.text = model.type?.localized.capitalized
    }
}
