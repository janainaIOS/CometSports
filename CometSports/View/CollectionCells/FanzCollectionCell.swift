//
//  FanzCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 21/02/2024.
//

import UIKit

class FanzCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subTitleLBL: UILabel!
    @IBOutlet weak var joinBTN: UIButton!
    
    func configure(model: Forum, _index: Int) {
        imageIV.setImage(imageStr: model.coverImageURL, placeholder: Images.fanZOne)
        titleLBL.text = model.title
        subTitleLBL.text = model.body
        joinBTN.setTitle(model.hasJoined ? "Leave".localized : "Join".localized, for: .normal)
        joinBTN.tag = _index
    }
}
