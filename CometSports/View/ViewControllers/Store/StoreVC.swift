//
//  StoreVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import UIKit

class StoreVC: UIViewController {
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var gridBTN: UIButton!
    @IBOutlet weak var lisrtBTN: UIButton!
    @IBOutlet weak var listCV: UICollectionView!
    
    var activityIndicator: ActivityIndicatorHelper!
    var productArray: [Product] = []
    var pageNum = 1
    var isPagination = false
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        getProductList()
    }
    
    override func viewDidLayoutSubviews() {
        listCV.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0)
    }
    
    // MARK: - Methods
    func initialSettings() {
        gridBTN.isSelected = true
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        nibInitialization()
        
    }
    func nibInitialization() {
        let nib = UINib(nibName: "StoreListCollectionCell", bundle: nil)
        let nib2 = UINib(nibName: "StoreGridCollectionCell", bundle: nil)
        listCV?.register(nib, forCellWithReuseIdentifier: "StoreListCollectionCell")
        listCV?.register(nib2, forCellWithReuseIdentifier: "StoreGridCollectionCell")
    }
    
    func getProductList() {
        searchTF.placeholder = "Search".localized
        searchTF.text = searchText
        activityIndicator.startAnimaton()
        ProductViewModel.shared.getProductList(searchText: self.searchText, pageNum: self.pageNum) { products, status, errorMsg  in
            self.activityIndicator.stopAnimaton()
            if self.pageNum == 1 {
                self.productArray.removeAll()
            }
            if status {
                if products.count > 0 {
                    self.productArray.append(contentsOf: products)
                    self.isPagination = false
                }
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
            
            self.listCV.reloadData()
            if self.productArray.count == 0 {
                self.listCV.setEmptyMessage(self.searchText.count > 1 ? ErrorMessage.searchEmptyAlert : ErrorMessage.productEmptyAlert)
            } else {
                self.listCV.restore()
            }
        }
    }
    // MARK: - Button Actions
    @IBAction func gridListBTNTapped(_ sender: UIButton) {
        gridBTN.isSelected.toggle()
        lisrtBTN.isSelected.toggle()
        listCV.backgroundColor = gridBTN.isSelected ? .black : .gray1
        listCV.reloadData()
    }
}

// MARK: - CollectionView Delegates
extension StoreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if gridBTN.isSelected {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreGridCollectionCell", for: indexPath) as! StoreGridCollectionCell
            cell.setCellValues(model: productArray[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreListCollectionCell", for: indexPath) as! StoreListCollectionCell
            cell.setCellValues(model: productArray[indexPath.row])
            return cell
        }
    }
}

extension StoreVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = Storyboards.store.instantiateViewController(withIdentifier: "StoreDetailVC") as! StoreDetailVC
        nextVC.productId = productArray[indexPath.row].id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if gridBTN.isSelected {
            return CGSize(width: (collectionView.frame.width / 2) - 8, height: 270)
        } else {
            return CGSize(width: collectionView.frame.width - 10, height: 110)
        }
    }
}

// MARK: - ScrollView Delegates
extension StoreVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.listCV {
            if(scrollView.contentOffset.y>0 && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
                if(isPagination == false){
                    isPagination = true
                    pageNum = pageNum + 1
                    self.getProductList()
                }
            }
        }
    }
}

// MARK: - TextField Delegate
extension StoreVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            self.searchText = text.replacingCharacters(in: textRange,with: string)
            print("searchText  \(searchText)")
            pageNum = 1
            getProductList()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text ?? ""
        print("searchText --  \(searchText)")
        pageNum = 1
        getProductList()
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        pageNum = 1
        searchText = ""
        textField.text = ""
        textField.resignFirstResponder()
        getProductList()
        return true
    }
}
