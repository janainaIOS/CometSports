//
//  StoreDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 01/06/2023.
//

import UIKit

class StoreDetailVC: UIViewController {
    
    @IBOutlet weak var imageCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var descriptnLBL: UILabel!
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var listCV: UICollectionView!
    @IBOutlet weak var listCVHeightConstrtaint: NSLayoutConstraint!
    @IBOutlet weak var productDetailLBL: UILabel!
    @IBOutlet weak var productLBL: UILabel!
    @IBOutlet weak var prizeTextLBL: UILabel!
    @IBOutlet weak var prizeLBL: UILabel!
    
    var activityIndicator: ActivityIndicatorHelper!
    var productId = 0
    var tagId = 0
    var pageNum = 1
    var isPagination = false
    var product = Product()
    var productArray: [Product] = []
    let imageCVLayout = CarouselFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh for localization
        productDetailLBL.text = "Product Detail".localized
        productLBL.text = "Related Products".localized
        getProductDetail()
    }
    
    // MARK: - Methods
    func initialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        nibInitialization()
        imageCVLayout.scrollDirection = .horizontal
        imageCVLayout.itemSize = CGSize(width: screenWidth - 30, height: 200)
        imageCV.collectionViewLayout = imageCVLayout
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "StoreGridCollectionCell", bundle: nil)
        listCV?.register(nib, forCellWithReuseIdentifier: "StoreGridCollectionCell")
        let nib2 = UINib(nibName: "ImageCollectionCell", bundle: nil)
        imageCV?.register(nib2, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    func getProductDetail() {
        activityIndicator.startAnimaton()
        ProductViewModel.shared.getProductDetail(id: productId) { response, status, errorMsg  in
            self.activityIndicator.stopAnimaton()
            if status {
                self.product = response
                self.setView()
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
        }
    }
    
    func setView() {
        prizeTextLBL.text = "Price".localized
        prizeLBL.text = "$\(self.product.price)"
        self.titleLBL.text = self.product.title
        self.descriptnLBL.text = self.product.descriptn
        self.tagId = self.product.tagList.first?.id ?? 0
        self.listCVHeightConstrtaint.constant = CGFloat((self.product.paramtList.count) * 50) + 120
        self.listTV.reloadData()
        self.pageControl.numberOfPages = self.product.photos.count
        self.pageControl.currentPage = 0
        self.imageCV.reloadData()
        self.getProductsByTag()
    }
    func getProductsByTag() {
        if self.tagId != 0 {
            activityIndicator.startAnimaton()
            ProductViewModel.shared.getProductsByTag(id: self.tagId, pageNum: pageNum) { products, status, errorMsg  in
                self.activityIndicator.stopAnimaton()
                
                if self.pageNum == 1 {
                    self.productArray.removeAll()
                }
                if status {
                    self.productArray.append(contentsOf: products)
                    self.isPagination = false
                } else {
                    Toast.show(message: errorMsg, view: self.view)
                }
                
                self.listCV.reloadData()
                
                if self.productArray.count == 0 {
                    self.listCV.setEmptyMessage(ErrorMessage.productEmptyAlert)
                } else {
                    self.listCV.restore()
                }
            }
        }
    }
    
    private func getIndexOfMajorCell() -> Int {
        let itemWidth = imageCVLayout.itemSize.width
        let proportionalOffset = imageCVLayout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = imageCV.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
}

// MARK: - TableView Delegates
extension StoreDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product.paramtList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableCell", for: indexPath) as! ListTableCell
        cell.titleLBL.text = self.product.paramtList[indexPath.row].title
        cell.valueLBL.text = self.product.paramtList[indexPath.row].value
        return cell
    }
}

extension StoreDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

// MARK: - CollectionView Delegates
extension StoreDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == imageCV ? product.photos.count : productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            cell.imageIV.setImage(imageStr: URLs.productImage + product.photos[indexPath.row].coverPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreGridCollectionCell", for: indexPath) as! StoreGridCollectionCell
            cell.setCellValues(model: productArray[indexPath.row], color: .black)
            return cell
        }
    }
}

extension StoreDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCV {
            let nextVC = Storyboards.store.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
            nextVC.imageName = product.photos[indexPath.row].coverPath
            nextVC.modalPresentationStyle = .overCurrentContext
            self.present(nextVC, animated: false, completion: nil)
        } else {
            let nextVC = Storyboards.store.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailVC
            nextVC.productId = productArray[indexPath.row].id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == imageCV {
            self.pageControl.currentPage = indexPath.row
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCV {
            return CGSize(width: screenWidth - 30, height: 200)
        } else {
            return CGSize(width: (collectionView.frame.width / 2) - 25, height: 260)
        }
    }
}

// MARK: - ScrollView Delegates
extension StoreDetailVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == imageCV {
           // let imageIndex = getIndexOfMajorCell()
           // self.pageControl.currentPage = imageIndex
        } else if scrollView == listCV {
            let threshold = 100.0 ;
            let contentOffset = scrollView.contentOffset.x;
            let maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;
            if ((maximumOffset - contentOffset <= threshold) && (maximumOffset - contentOffset != -5.0) ){
                if(isPagination == false){
                    isPagination = true
                    pageNum = pageNum + 1
                    self.getProductsByTag()
                }
            }
        }
    }
}
