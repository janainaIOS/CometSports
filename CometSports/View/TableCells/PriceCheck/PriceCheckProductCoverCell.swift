//
//  PriceCheckProductCoverCell.swift
//  Comet Sports
//
//  Created by iosDeva on 7/27/23.
//

import UIKit

class PriceCheckProductCoverCell: UITableViewCell {

    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(link1:String,link2:String,link3:String,link4:String){
        image1.setImage(imageStr: URLs.productImage + link1)
        image2.setImage(imageStr:  URLs.productImage + link2)
        image3.setImage(imageStr:  URLs.productImage + link3)
        image4.setImage(imageStr:  URLs.productImage + link4)
    }
    
}
