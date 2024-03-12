//
//  AnalystVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import UIKit

class AnalystVC: UIViewController {
    
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var listCV: UICollectionView!
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var userRecmntLBL: UILabel!
    @IBOutlet weak var userWinRateLBL: UILabel!
    
    var activityIndicator: ActivityIndicatorHelper!
    var analystVM = AnalystViewModel.shared
    var isPagination = false
    var pageNum = 25
    var analystArray: [Analyst] = []
    var winAnalystArray: [Analyst] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        var pageNum = 25
        // Refresh for localization
        headerLBL.text = "Analysts & Prediction".localized
        userRecmntLBL.text = "Analyst Recomendation".localized
        userWinRateLBL.text = "Analyst with high winrate".localized
        getAnalystList()
    }
    // MARK: - Methods
    func initialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        nibInitialization()
    }
    func nibInitialization() {
        let nib = UINib(nibName: "AnalystGridCollectionCell", bundle: nil)
        listCV?.register(nib, forCellWithReuseIdentifier: "AnalystGridCollectionCell")
    }
    
    func getAnalystList() {
        activityIndicator.startAnimaton()
        analystVM.getAnalystList(pageNum: pageNum) { status, errorMsg  in
            self.activityIndicator.stopAnimaton()
            
            if self.pageNum == 25 {
                self.analystArray.removeAll()
            }
            if status {
                if self.analystVM.analystArray.count > 0 {
                    self.analystArray.append(contentsOf: self.analystVM.analystArray)
                    self.isPagination = false
                }
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
            self.analystArray = self.analystArray.uniques(by: \.name)
            if self.analystArray.count == 0 {
                self.listTV.setEmptyMessage(ErrorMessage.analystEmptyAlert)
                self.listCV.setEmptyMessage(ErrorMessage.analystEmptyAlert)
            } else {
                self.listTV.restore()
                self.listCV.restore()
            }
            self.winAnalystArray = self.analystArray.sorted(by: { $0.winRate > $1.winRate })
            self.listTV.reloadData()
            self.listCV.reloadData()
        }
    }
    func goToAnalystDetailVC(id: String) {
        let nextVC = Storyboards.analyst.instantiateViewController(withIdentifier: "AnalystDetailVC") as! AnalystDetailVC
        nextVC.analystId = id
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - TableView Delegates
extension AnalystVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analystArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnalystTableCell", for: indexPath) as! AnalystTableCell
        cell.setCellValues(model: self.analystArray[indexPath.row])
        return cell
    }
}

extension AnalystVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToAnalystDetailVC(id: self.analystArray[indexPath.row].id)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - CollectionView Delegates
extension AnalystVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.winAnalystArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnalystGridCollectionCell", for: indexPath) as! AnalystGridCollectionCell
        cell.setCellValues(model: self.winAnalystArray[indexPath.row])
        return cell
    }
}

extension AnalystVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToAnalystDetailVC(id: self.winAnalystArray[indexPath.row].id)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10, height: 180)
    }
}


// MARK: - ScrollView Delegates
extension AnalystVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.listTV {
            if(scrollView.contentOffset.y>0 && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
                if(isPagination == false){
                    isPagination = true
                    pageNum = pageNum + 10
                    self.getAnalystList()
                }
            }
        }
    }
}
