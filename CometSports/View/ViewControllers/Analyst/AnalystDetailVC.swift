//
//  AnalystDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 30/05/2023.
//

import UIKit

class AnalystDetailVC: UIViewController {
    
    @IBOutlet weak var topIV: UIImageView!
    @IBOutlet weak var photoIV: UIImageView!
    @IBOutlet weak var winRateLBL: UILabel!
    @IBOutlet weak var followerLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var winCountLBL: UILabel!
    @IBOutlet weak var totalAnalysisLBL: UILabel!
    @IBOutlet weak var totalPostLBL: UILabel!
    @IBOutlet weak var matchListLBL: UILabel!
    @IBOutlet weak var listCV: UICollectionView!
    @IBOutlet weak var relativeTimeLBL: UILabel!
    @IBOutlet weak var explantnTxtView: UITextView!
    @IBOutlet weak var explantnTxtViewHeightConstraint: NSLayoutConstraint!
    
    var activityIndicator: ActivityIndicatorHelper!
    let listCVLayout = CarouselFlowLayout()
    var analystId = ""
    var analystVM = AnalystViewModel.shared
    var model = AnalystDetail()
    var expandIndexArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh for localization
        matchListLBL.text = "Match List".localized
        getAnalystDetail()
    }
    
    override func viewDidLayoutSubviews() {
      //  listTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    // MARK: - Methods
    func initialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
//        listCVLayout.scrollDirection = .horizontal
//        listCVLayout.itemSize = CGSize(width: screenWidth - 30, height: 200)
//        listCV.collectionViewLayout = listCVLayout
    }
    
    func getAnalystDetail() {
        activityIndicator.startAnimaton()
        analystVM.getAnalystDetail(id: analystId) { analyst, status, errorMsg  in
            self.activityIndicator.stopAnimaton()
            if status {
                self.model = analyst
                self.expandIndexArray.removeAll()
                self.setView()
                self.listCV.reloadData()
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
        }
    }
    
    func getAnalysis(userID: String, matchID: String) {
        activityIndicator.startAnimaton()
        analystVM.getAnalysis(userId: userID, matchId: matchID) { analystMatch, status, errorMsg  in
            self.activityIndicator.stopAnimaton()
            if status {
                if let indexOfMatch = self.model.matchList.firstIndex(where: { $0.matchId == matchID }) {
                    self.model.matchList[indexOfMatch].explanation = analystMatch.explanation
                    self.model.matchList[indexOfMatch].relativeTime = analystMatch.relativeTime
                }
                self.listCV.reloadData()
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
        }
    }
    
    func setView() {
        photoIV.setImage(imageStr: model.user.image, placeholder: UIImage(named: "user"))
        winRateLBL.text = "Winrate ".localized + "\(model.user.winRate)%"
        followerLBL.text = "\(model.user.totalFollower)" + " followers".localized
        nameLBL.text = model.user.name
        winCountLBL.text = "\(model.user.wonFootballAnalysis)" + " Top Win In Games".localized
        totalAnalysisLBL.text = "\(model.user.totalAnalysis)" + " Analysis".localized
        totalPostLBL.text = "\(model.user.totalPost)" + " Posts".localized
    }
}


// MARK: - CollectionView Delegates
extension AnalystDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.matchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCollectionCell", for: indexPath) as! MatchCollectionCell
        cell.setCellValues(model: model.matchList[indexPath.row])
        return cell
    }
}

extension AnalystDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if model.matchList[indexPath.row].explanation == "" {
            getAnalysis(userID: model.user.id, matchID: model.matchList[indexPath.row].matchId)
        } else {
            
        }
        relativeTimeLBL.text =  model.matchList[indexPath.row].relativeTime
        explantnTxtView.text =  model.matchList[indexPath.row].explanation
        let heightOfExpatnText = explantnTxtView.text.heightOfString2(width: screenWidth - 10, font: appFontRegular(13))
        explantnTxtViewHeightConstraint.constant = heightOfExpatnText + 100
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: screenWidth - 20 , height: 190)
        return cellSize
    }
}
