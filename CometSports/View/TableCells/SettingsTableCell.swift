//
//  SettingsTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 03/06/2023.
//

import UIKit

class SettingsTableCell: UITableViewCell {
    
    @IBOutlet weak var iconIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCellValues(type: SettingsList) {
        titleLBL.textColor = type == .delete ? .base2Color : .white
        iconIV.tintColor = type == .delete ? .base2Color : .baseColor
        
        titleLBL.text = type.rawValue.localized
        switch type {
        case .account:
            iconIV.image = UIImage(named: "Profile")
        case .edit :
            iconIV.image = UIImage(named: "Profile")
        case .language:
            iconIV.image = UIImage(named: "globe")
        case .privacy :
            iconIV.image = UIImage(named: "PrivacyPolicy")
        case .rate :
            iconIV.image = UIImage(named: "Rate")
        case .delete :
            iconIV.image = UIImage(named: "deleteAccount")
        default: //contact us
            iconIV.image = UIImage(named: "chat-square")
        }
    }
}
