//
//  SegmentsCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 02/03/2024.
//

import UIKit

class SegmentsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellValues(selected: Bool, title: String) {
        titleLBL.text = title.localized
        titleLBL.font = appFontRegular(selected ? 17 : 14)
        lineView.backgroundColor = selected ? .baseColor : .clear
    }
}
