//
//  ShortStatsTableViewCell.swift
//  Comet Sports
//
//  Created by iosDev on 7/28/23.
//

import UIKit

protocol ShortStatsUpdateDelegate{
    func updateCell(expensive:Product?,cheap:Product?,average:String)
    func updateFinished()
    func starLoading()
}

class ShortStatsTableViewCell: UITableViewCell {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var averagePrice: UILabel!
    @IBOutlet weak var averagePriceLocalizable: UILabel!
    @IBOutlet weak var cheapestButton: UIButton!
    @IBOutlet weak var cheapestPrice: UILabel!
    @IBOutlet weak var cheapestLocalizable: UILabel!
    @IBOutlet weak var buttonMostExp: UIButton!
    @IBOutlet weak var priceMostExp: UILabel!
    @IBOutlet weak var mostExpLocalizable: UILabel!
    @IBOutlet weak var seeAllBTN: UIButton!
    @IBOutlet weak var activityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var loadingLBL: UILabel!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        activityIndictor.startAnimating()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(expensive:Product,cheap:Product,average:String){
        loadingLBL.text = "Loading More Data".localized
        averagePriceLocalizable.text = "Average Product Price:".localized
        cheapestLocalizable.text = "Cheapest Product Price:".localized
        mostExpLocalizable.text = "Most Expensive Product Price:".localized
        priceMostExp.text=expensive.price
        cheapestPrice.text=cheap.price
        averagePrice.text=average
        buttonMostExp.setTitle("See Product".localized, for: .normal)
        cheapestButton.setTitle("See Product".localized, for: .normal)
        seeAllBTN.setTitle("See All Product".localized, for: .normal)
    }
    
}
extension ShortStatsTableViewCell:ShortStatsUpdateDelegate{
    func starLoading() {
        loadingView.isHidden=false
        activityIndictor.startAnimating()
    }
    
    func updateFinished() {
        loadingView.isHidden=true
        activityIndictor.stopAnimating()
    }
    
    func updateCell(expensive: Product?, cheap: Product?, average: String) {
        priceMostExp.text=expensive?.price
        cheapestPrice.text=cheap?.price
        averagePrice.text=average
}
    
    
}


