//
//  PostCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 16/02/2024.
//

import UIKit

class PostCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var forumNameLBL: UILabel!
    @IBOutlet weak var forumBTN: UIButton!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var imageCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreBTN: UIButton!
    @IBOutlet weak var detailLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(model: Post?, feedCell: Bool = true, _index: Int) {
        userImageIV.setImage(imageStr: model?.user?.image ?? "", placeholder: Images.user)
        userNameLBL.text = model?.user?.fullName
        nameTopConstraint.constant = feedCell == true ? 0 : 10
        forumNameLBL.text = feedCell == true ? model?.forumName ?? "" : ""
        dateLBL.text = model?.createdAt?.formatDate2(inputFormat: dateFormat.yyyyMMddHHmmss)
        titleLBL.text = model?.title
        if let attributedText = model?.contentHTML?.attributedHtmlString {
            detailLBL.text = attributedText.string
        }
        titleLBL.numberOfLines = feedCell == true ? 0 : 1
        detailLBL.numberOfLines = feedCell == true ? 0 : 2
        imageIV.setImage(imageStr: model?.postImages?.first?.url ?? "", placeholder: Images.noImage)
        if feedCell {
            imageCVHeightConstraint.constant = model?.postImages?.count == 0 ? 0 : 150
        } else {
            imageCVHeightConstraint.constant = model?.postImages?.count == 0 ? 0 : 100
        }
        moreBTN.isHidden = false
        moreBTN.tag = _index
        forumBTN.tag = _index
    }
}
