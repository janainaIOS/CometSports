//
//  MediaTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 15/02/2024.
//

import UIKit

class MediaTableCell: UITableViewCell {

    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subTitleLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var rightBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setMediaCellValues(model: Medias) {
        imageIV.setImage(imageStr: model.preview)
        dateLBL.text = model.date.formatDate(inputFormat: dateFormat.yyyyMMdd, outputFormat: dateFormat.hmmaEEEE)
        titleLBL.text = model.title
        subTitleLBL.text = model.subtitle
    }
}
