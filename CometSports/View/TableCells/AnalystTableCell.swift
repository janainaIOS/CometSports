//
//  AnalystTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 29/05/2023.
//

import UIKit

class AnalystTableCell: UITableViewCell {

    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var winCountLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var winRateLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellValues(model: Analyst) {
        imageIV.setImage(imageStr: model.image, placeholder: UIImage(named: "user"))
        winCountLBL.text = "\(model.wonFootballAnalysis) \("of".localized) \(model.totalFootballAnalysis)"
        nameLBL.text = model.name
        winRateLBL.text = "Winrate ".localized + "\(model.winRate)%"
    }
}
