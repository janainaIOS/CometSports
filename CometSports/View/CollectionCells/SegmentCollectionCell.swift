//
//  SegmentCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 11/07/2023.
//

import UIKit

class SegmentCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    func setCellValues(selected: Bool, title: String) {
        titleLBL.text = title.localized
        titleLBL.font = appFontRegular(selected ? 17 : 14)
        lineView.backgroundColor = selected ? .baseColor : .clear
    }
}
