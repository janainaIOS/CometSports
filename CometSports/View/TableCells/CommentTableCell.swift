//
//  CommentTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 24/02/2024.
//

import UIKit

class CommentTableCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteButtonHeightConstaint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureComments(model: Comment, _index: Int, listView: Bool = false) {
        let commentOwner = (UserDefaults.standard.user?.id ?? 0) == model.user.id
        
        userImageView?.setImage(imageStr: model.user.image, placeholder: Images.user)
        nameLabel.text = model.user.fullName
        commentLabel.text = model.comment
        dateLabel.text = model.createdTime.formatDate2(inputFormat: dateFormat.yyyyMMddHHmmssTimeZone)
        
        ///listView - comment list page or any detail page
        commentLabel.numberOfLines = listView ? 0 : 1
        deleteButton?.tag = _index
        deleteButtonHeightConstaint?.constant = (commentOwner && listView) ? 40 : 0
    }
}
