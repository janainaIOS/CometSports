//
//  NewsCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 15/02/2024.
//

import UIKit

class NewsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subTitleLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellValues(model: News) {
        imageIV.setImage(imageStr: model.path, placeholder: Images.noImage)
        
        if let attributedText = model.title.attributedHtmlString {
            titleLBL.text = attributedText.string
        }
//        if let attributedText = model.descriptn.attributedHtmlString {
//            subTitleLBL.text = attributedText.string
//        }
        subTitleLBL.text = model.date.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssTimeZone, outputFormat: dateFormat.ddMMMyyyyEEE)
        self.layoutIfNeeded()
    }
}
