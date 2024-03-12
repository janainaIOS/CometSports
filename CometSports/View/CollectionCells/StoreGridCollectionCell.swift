//
//  StoreGridCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 29/05/2023.
//

import UIKit

class StoreGridCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var descriptnLBL: UILabel!
    @IBOutlet weak var prizeLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCellValues(model: Product, color: UIColor = .gray2) {
        bgView.backgroundColor = color
        imageIV.setImage(imageStr: URLs.productImage + (model.coverPath ?? ""))
        titleLBL.text = model.title
        prizeLBL.text = "$\(model.price)"
        descriptnLBL.text = model.descriptn
    }
}
