//
//  FanZoneTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 16/02/2024.
//

import UIKit

class FanZoneTableCell: UITableViewCell {
    
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var joinBTN: UIButton!
    @IBOutlet weak var listCV: UICollectionView!
    @IBOutlet weak var listCVHeightConstraint: NSLayoutConstraint!
    
    var postArray: [Post] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nibInitialization()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "PostCollectionCell", bundle: nil)
        listCV?.register(nib, forCellWithReuseIdentifier: "PostCollectionCell")
    }
    
    func configure(model: Forum, _index: Int) {
        postArray = model.postList
        imageIV.setImage(imageStr: model.coverImageURL, placeholder: Images.fanZOne)
        titleLBL.text = model.title
        joinBTN.setTitle("Join".localized, for: .normal)
        joinBTN.tag = _index
        listCVHeightConstraint.constant = model.postList.count > 0 ? (model.haveImage ? 285 : 180) : 0
        listCV.reloadData()
    }
}

// MARK: - CollectionView Delegates
extension FanZoneTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.postArray.count == 0 {
            self.listCV.setEmptyMessage(ErrorMessage.postEmptyAlert)
        } else {
            self.listCV.restore()
        }
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as! PostCollectionCell
        cell.configure(model: postArray[indexPath.row], feedCell: false, _index: 0)
        cell.moreBTN.isHidden = true
        
        return cell
    }
}

extension FanZoneTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension FanZoneTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageHeight = postArray[indexPath.row].postImages?.count == 0 ? 0 : 120
        let cellHeight: CGFloat = CGFloat(160 + imageHeight)
        return CGSize(width: (collectionView.frame.width * 0.85), height: cellHeight)
    }
}
