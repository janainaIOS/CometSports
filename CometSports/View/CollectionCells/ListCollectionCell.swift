//
//  ListCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 12/07/2023.
//

import UIKit

class ListCollectionCell: UICollectionViewCell {

    @IBOutlet weak var valueLBL: UILabel!
    @IBOutlet weak var nameView: UIStackView!
    @IBOutlet weak var indexLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var imageBGView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
