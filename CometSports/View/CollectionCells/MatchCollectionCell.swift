//
//  MatchCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 29/07/2023.
//

import UIKit

class MatchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLBL: UILabel!
    @IBOutlet weak var homeIconIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayIconIV: UIImageView!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    
    func setCellValues(model: AnalystMatch) {
        
        leagueLBL.text = model.league
        resultView.backgroundColor = UIColor(hexString: model.color)
        resultLBL.text = model.finalResult.getSportResult().localized
        homeLBL.text = model.homeTeam
        homeIconIV.setImage(imageStr: model.homeLogo, placeholder: UIImage(named: "NoLeague"))
        awayLBL.text = model.awayTeam
        awayIconIV.setImage(imageStr: model.awayLogo, placeholder: UIImage(named: "NoLeague"))
        scoreLBL.text = "\(model.homeScore) - \(model.awayScore)"
        timeLBL.text = model.date.formatDate(inputFormat: dateFormat.yyyyMMddHHmmss, outputFormat: dateFormat.hmma)
        dateLBL.text = model.date.formatDate(inputFormat: dateFormat.yyyyMMddHHmmss, outputFormat: dateFormat.ddMMyyyy2)
    }
}
