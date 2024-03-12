//
//  CalenderCollectionCell.swift
//  Comet Sports
//
//  Created by iosDev on 10/07/2023.
//

import UIKit

class CalenderCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dayLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    
    func setCellValues(dateString: String, selectedDateText: String) {
        let selected = dateString == selectedDateText
        bgView.backgroundColor = selected ? .base2Color : .black
        dayLBL.textColor = selected ? .white : .lightGray
        dateLBL.textColor = selected ? .violet1 : .darkGray
        
        dayLBL.text = dateString.formatDate(inputFormat: .ddMMyyyy, outputFormat: .e)
        dateLBL.text = dateString.formatDate(inputFormat: .ddMMyyyy, outputFormat: .dd)
    }
}
