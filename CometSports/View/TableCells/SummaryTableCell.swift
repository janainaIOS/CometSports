//
//  SummaryTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 11/07/2023.
//

import UIKit

class SummaryTableCell: UITableViewCell {
    
    @IBOutlet weak var actionIconIV: UIImageView!
    @IBOutlet weak var actionLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var contentLBL: UILabel!
    @IBOutlet weak var mainPlayerView: UIView!
    @IBOutlet weak var subPlayerView: UIView!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var mainPlayerIV: UIImageView!
    @IBOutlet weak var mainPlayerLBL: UILabel!
    @IBOutlet weak var subPlayerIV: UIImageView!
    @IBOutlet weak var subPlayerLBL: UILabel!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCellValues(model: ProgressData) {
        actionIconIV.image = model.action.progressData().0
        actionLBL.text = model.action.progressData().1
        timeLBL.text = model.time
        contentLBL.text = model.action.progressData(mPlayer: model.mainPlayer, sPlayer: model.subPlayer).2
        let contentHeight = model.action.progressData(mPlayer: model.mainPlayer, sPlayer: model.subPlayer).2.heightOfString2(width: screenWidth - 150, font: appFontRegular(15))
        contentHeightConstraint.constant = contentHeight < 45 ? 45 : contentHeight
        mainPlayerView.isHidden = (model.action != "goal" && model.action != "substitute")
        subPlayerView.isHidden = model.action != "substitute"
        midView.isHidden = model.action != "substitute"
        mainPlayerIV.setImage(imageStr: model.mainPlayerImage, placeholder: UIImage(named: "user2"))
        subPlayerIV.setImage(imageStr: model.subPlayerImage, placeholder: UIImage(named: "user2"))
        mainPlayerLBL.text = model.mainPlayer
        subPlayerLBL.text = model.subPlayer
        
    }
}
