//
//  FormPostCollectionViewCell.swift
//  Comet Sports
//
//  Created by iosDev on 01/03/2024.
//

import UIKit

class FormPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(model: Post?) {
        userImageIV.setImage(imageStr: model?.user?.image ?? "", placeholder: Images.user)
        userNameLBL.text = model?.user?.fullName
        dateLBL.text = model?.createdAt?.formatDate2(inputFormat: dateFormat.yyyyMMddHHmmss)
        titleLBL.text = model?.title
        if let attributedText = model?.contentHTML?.attributedHtmlString {
            detailLBL.text = attributedText.string
        }
        imageIV.setImage(imageStr: model?.postImages?.first?.url ?? "", placeholder: Images.noImage)
       imageHeightConstraint.constant = model?.postImages?.count == 0 ? 0 : 100
      
    }
}
