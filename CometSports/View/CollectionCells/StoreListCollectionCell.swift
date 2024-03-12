//
//  StoreListCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 29/05/2023.
//

import UIKit

class StoreListCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var prizeLBL: UILabel!
    @IBOutlet weak var descriptnTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCellValues(model: Product) {
        imageIV.setImage(imageStr: URLs.productImage + (model.coverPath))
        titleLBL.text = model.title
        prizeLBL.text = "$\(model.price)"
        descriptnTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        descriptnTextView.text = model.descriptn
    }
}
