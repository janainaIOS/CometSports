//
//  AnalystGridCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 29/05/2023.
//

import UIKit

class AnalystGridCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var winRateLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellValues(model: Analyst) {
        imageIV.setImage(imageStr: model.image, placeholder: UIImage(named: "user"))
        nameLBL.text = model.name
        winRateLBL.text = "Winrate ".localized + "\(model.winRate)%"
    }
}
