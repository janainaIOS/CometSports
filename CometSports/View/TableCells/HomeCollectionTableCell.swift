//
//  HomeCollectionTableCell.swift
//  Comet Sports
//
//  Created by iosDev on 16/02/2024.
//

import UIKit

protocol HomeCollectTVCellDelegate:AnyObject {
    func newsPagination()
    func newsSelected(id: Int)
    func moreBTNTapped(_index: Int)
}

class HomeCollectionTableCell: UITableViewCell {
    
    @IBOutlet weak var listCV: UICollectionView!
    
    weak var delegate: HomeCollectTVCellDelegate?
    var homeSection: HomeHeaders = .topNews
    var newsArray: [News] = []
    var feedPost: Post?
    var _index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nibInitialization()
        listCV.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "NewsCollectionCell", bundle: nil)
        listCV?.register(nib, forCellWithReuseIdentifier: "NewsCollectionCell")
        let nib2 = UINib(nibName: "PostCollectionCell", bundle: nil)
        listCV?.register(nib2, forCellWithReuseIdentifier: "PostCollectionCell")
    }
    
    func configure(section: HomeHeaders) {
        homeSection = section
        listCV.dataSource = self
        listCV.delegate = self
        if let flowLayout = listCV.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = section == .topNews ? .horizontal : .vertical
        }
        listCV.reloadData()
    }
    @objc func moreBTNTapped(sender: UIButton) {
        delegate?.moreBTNTapped(_index: _index)
    }
}

// MARK: - CollectionView Delegates
extension HomeCollectionTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if homeSection == .topNews {
            if newsArray.count == 0 {
                self.listCV.setEmptyMessage(ErrorMessage.dataEmptyAlert)
            } else {
                self.listCV.restore()
            }
            return newsArray.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if homeSection == .topNews {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionCell", for: indexPath) as! NewsCollectionCell
            cell.setCellValues(model: newsArray[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostCollectionCell", for: indexPath) as! PostCollectionCell
            cell.moreBTN.addTarget(self, action: #selector(moreBTNTapped(sender:)), for: .touchUpInside)
            cell.configure(model: feedPost, _index: 0)
            cell
            return cell
        }
    }
}

extension HomeCollectionTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if homeSection == .topNews {
            delegate?.newsSelected(id: newsArray[indexPath.row].id)
        }
    }
}

extension HomeCollectionTableCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if homeSection == .topNews {
            return CGSize(width: (collectionView.frame.width * 0.85), height: 230)
        } else {
            return CGSize(width: collectionView.frame.width , height: 230)
        }
    }
}


// MARK: - ScrollView Delegates

extension HomeCollectionTableCell {
    /// for news pagination
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.listCV && homeSection == .topNews {
            let threshold = 100.0 ;
            let contentOffset = scrollView.contentOffset.x;
            let maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;
            if ((maximumOffset - contentOffset <= threshold) && (maximumOffset - contentOffset != -5.0) ){
                delegate?.newsPagination()
            }
        }
    }
}

