//
//  CollectionTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 12/07/2023.
//

import UIKit

class CollectionTableCell: UITableViewCell {

    @IBOutlet weak var listCV: UICollectionView!
    
    var valueArray: [String] = []
    var _isHeader: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nibInitialization()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "ListCollectionCell", bundle: nil)
        listCV?.register(nib, forCellWithReuseIdentifier: "ListCollectionCell")
    }
    
    func setCellValues(array: [String], isHeader: Bool) {
       // print("array__  \(array)")
        valueArray = array
        _isHeader = isHeader
        listCV.reloadData()
        listCV.layoutSubviews()
    }
}

extension CollectionTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (valueArray.count - 3) > 0 ? valueArray.count - 3 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionCell", for: indexPath) as! ListCollectionCell
        cell.imageBGView.isHidden = _isHeader
        cell.nameView.isHidden = indexPath.row != 0
        cell.valueLBL.isHidden = indexPath.row == 0
        cell.valueLBL.font = appFontRegular(_isHeader ? 11 : 10)
        
        cell.indexLBL.text = valueArray[0]
        cell.imageIV.setImage(imageStr: valueArray[1], placeholder: UIImage(named: "user2"))
        cell.nameLBL.text = valueArray[3]
        if valueArray.indices.contains(indexPath.row + 3) {
            cell.valueLBL.text = valueArray[indexPath.row + 3] == "" ? "-" : valueArray[indexPath.row + 3]
        }
        return cell
    }
}

extension CollectionTableCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nameWidth = (collectionView.frame.width / 2) - 20
        let widthForOthers = collectionView.frame.width - nameWidth
        let smallCellWidth = (widthForOthers / CGFloat((valueArray.count - 3))) + 3
        if screenWidth > 390 {
            return CGSize(width: indexPath.row == 0 ? (nameWidth + 20) : (smallCellWidth + 9), height: collectionView.frame.height)
        } else {
            return CGSize(width: indexPath.row == 0 ? nameWidth : smallCellWidth, height: collectionView.frame.height)
        }
    }
}
