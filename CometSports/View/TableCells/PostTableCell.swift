//
//  PostTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 28/02/2024.
//

import UIKit

class PostTableCell: UITableViewCell {
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var forumNameLBL: UILabel!
    @IBOutlet weak var forumBTN: UIButton!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moreBTN: UIButton!
    @IBOutlet weak var detailLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
///Copy of post collection cell
    func configure(model: Post?, feedCell: Bool = true, _index: Int) {
        userImageIV.setImage(imageStr: model?.user?.image ?? "", placeholder: Images.user)
        userNameLBL.text = model?.user?.fullName
        forumNameLBL.text = feedCell == true ? model?.forumName ?? "" : ""
        dateLBL.text = model?.createdAt?.formatDate2(inputFormat: dateFormat.yyyyMMddHHmmss)
        titleLBL.text = model?.title
        if let attributedText = model?.contentHTML?.attributedHtmlString {
            detailLBL.text = attributedText.string
        }
        detailLBL.numberOfLines = feedCell == true ? 0 : 2
        imageIV.setImage(imageStr: model?.postImages?.first?.url ?? "", placeholder: Images.noImage)
        imageHeightConstraint.constant = model?.postImages?.count == 0 ? 0 : 150
        moreBTN.isHidden = false
        moreBTN.tag = _index
        forumBTN.tag = _index
    }
}
