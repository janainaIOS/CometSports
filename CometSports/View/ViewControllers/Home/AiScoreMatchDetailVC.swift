//
//  AiScoreMatchDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 02/03/2024.
//

import UIKit

class AiScoreMatchDetailVC: UIViewController {

    @IBOutlet weak var leagueImageIV: UIImageView!
    @IBOutlet weak var leagueNameLBL: UILabel!
    @IBOutlet weak var homeIconIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var statusLBL: UILabel!
    @IBOutlet weak var awayIconIV: UIImageView!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var segmentCV: UICollectionView!
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var matchesTV: UITableView!
    
    var activityIndicator: ActivityIndicatorHelper!
    var headerTitleArray = ["Overview".localized, "Match info".localized, "Odds".localized, "H2H".localized]
    var homeInfoKeyArr = ["half_time_score", "red_cards", "corner_score", "overtime_score", "penalty_score"]
    var awayInfoKeyArr = ["half_time_score", "red_card", "yellow_cards", "corner_score", "overtime_score", "penalty_score"]
    var basketballSectionKeyArr = ["section_1","section_2","section_3","section_4","overtime_score"]
    var basketballSectionHomeValueArr = [Int]()
    var basketballSectionAwayValueArr = [Int]()
    var homeInfoValueArr = [Int]()
    var awayInfoValueArr = [Int]()
    var coverageKeyArr = [String]()
    var coverageValueArr = [String]()
    var roundKeyArr = [String]()
    var roundValueArr = [String]()
    var environmentKeyArr = [String]()
    var environmentValueArr = [String]()
    var selectedIndex = 0
    var positionKeyArr = ["home_position", "away_position"]
    var positionValueArr = [String]()
    var infoKeyArr = [String]()
    var infoValueArr = [String]()
    var leagueName = String()
    var leagueLogo = String()
    var match = MatchList()
    var isFootball: Bool? = true
    var matchForH2HArr = [MatchInfo]()
    var matchStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    func configure() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        nibInitialization()
        highlightFirstIndex_collectionView()
        
        let homeDict = match.homeInfo.dictionary
        if isFootball ?? true {
            for i in homeInfoKeyArr {
                homeInfoValueArr.append(homeDict[i] as? Int ?? 0)
            }
            homeInfoValueArr.insert(0, at: 2)
        }else {
            for i in basketballSectionKeyArr {
                basketballSectionHomeValueArr.append(homeDict[i]as? Int ?? 0)
            }
        }
        
        let awayDict = match.awayInfo.dictionary
        if isFootball ?? true {
            for i in awayInfoKeyArr {
                awayInfoValueArr.append(awayDict[i] as? Int ?? 0)
            }
        }else {
            for i in basketballSectionKeyArr {
                basketballSectionAwayValueArr.append(homeDict[i]as? Int ?? 0)
            }
        }
        
        if isFootball ?? true {
            positionValueArr.append(match.homePosition)
            positionValueArr.append(match.awayPosition)
        }else {
            let positionDict = match.matchPosition?.dictionary ?? [:]
            if positionDict.isEmpty {
                positionValueArr.append("__")
                positionValueArr.append("__")
            }else {
                for i in positionDict {
                    positionValueArr.append(i.value as? String ?? "")
                }
            }
        }
        
        if ((match.coverage.dictionary.isEmpty) == false) {
            for (key,value) in match.coverage.dictionary {
                coverageKeyArr.append(key)
                coverageValueArr.append("\(value)")
            }
        }
        
        if ((match.round.dictionary.isEmpty) == false) {
            for (key,value) in match.round.dictionary {
                roundKeyArr.append(key)
                roundValueArr.append("\(value)")
            }
        }
        
        if ((match.environment.dictionary.isEmpty) == false) {
            for (key,value) in match.environment.dictionary {
                environmentKeyArr.append(key)
                environmentValueArr.append("\(value)")
            }
        }
        
        infoKeyArr = coverageKeyArr + roundKeyArr + environmentKeyArr + positionKeyArr
        infoValueArr = coverageValueArr + roundValueArr + environmentValueArr + positionValueArr
        
        let homeImage = match.homeInfo.logo
        let awayImage = match.awayInfo.logo
        
        self.leagueNameLBL.text = selectedLang == .zh ? match.leagueInfo.cnName : match.leagueInfo.enName
        
        self.leagueImageIV.setImage(imageStr: match.leagueInfo.logo, placeholder: Images.league)
        self.homeLBL.text = selectedLang == .zh ? match.homeInfo.cnName : match.homeInfo.enName
        self.awayLBL.text = selectedLang == .zh ? match.awayInfo.cnName : match.awayInfo.enName
        self.scoreLBL.text = "\(match.homeInfo.homeScore) - \(match.awayInfo.awayScore)"
        self.homeIconIV.setImage(imageStr: homeImage, placeholder: Images.league)
        self.awayIconIV.setImage(imageStr: awayImage, placeholder: Images.league)
        dateLBL.text = match.matchDate.formatDate(inputFormat: dateFormat.yyyyMMddHHmmss, outputFormat: dateFormat.ddMMyyyy2)
        statusLBL.text = match.statusID.getMatchStatus()
    }
    
    func nibInitialization() {
        segmentCV.register("SegmentsCollectionCell")
        matchesTV.register("StatisticsTableCell")
    }
    
    func highlightFirstIndex_collectionView() {
        //code to show collectionView cell default first index selected
        let indexPath = IndexPath(item: 0, section: 0)
        segmentCV.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView(segmentCV, didSelectItemAt: indexPath)
    }
}

// MARK: - CollectionView Delegates
extension AiScoreMatchDetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerTitleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentsCollectionCell", for: indexPath) as! SegmentsCollectionCell
        cell.setCellValues(selected: selectedIndex == indexPath.item, title: headerTitleArray[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        
        if selectedIndex == 3 {
            if isFootball ?? true {
                // footballH2HMatchesViewModel.fetchFootballH2HMatches(matchId: matchId)
            }else {
                // basketballH2HMatchesViewModel.fetchBasketballH2HMatches(matchId: matchId)
            }
            activityIndicator.startAnimaton()
            HomeViewModel.shared.getFootballH2HMatches(matchId: match.id) { response, status, message in
                self.activityIndicator.stopAnimaton()
                self.matchForH2HArr = (response.history?.homeMatchInfo ?? []) + (response.history?.awayMatchInfo ?? [])
                self.matchesTV.separatorStyle = .none
                self.matchesTV.reloadData()
            }
        }
        collectionView.reloadData()
        matchesTV.separatorStyle = .singleLine
        matchesTV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let selected = selectedIndex == indexPath.item
        return CGSize(width: headerTitleArray[indexPath.item].localized.size(withAttributes: [NSAttributedString.Key.font : selected ? appFontBold(17) : appFontRegular(17)]).width + 15, height: 50)
    }
}

// MARK: - TableView Data source and Delegates
extension AiScoreMatchDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedIndex {
        case 0:
            if isFootball ?? true {
                return awayInfoKeyArr.count
            } else {
                return basketballSectionKeyArr.count
            }
        case 1:
            if infoKeyArr.count == 0 {
                tableView.setEmptyMessage(ErrorMessage.dataEmptyAlert)
            } else {
                tableView.restore()
            }
            return infoKeyArr.count
            
        case 2:
            return 3
            
        default:
            if matchForH2HArr.count == 0 {
                tableView.setEmptyMessage(ErrorMessage.dataEmptyAlert)
            } else {
                tableView.restore()
            }
            return matchForH2HArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch selectedIndex {
        case 0:
            let cell = matchesTV.dequeueReusableCell(withIdentifier: "StatisticsTableCell", for: indexPath) as! StatisticsTableCell
            cell.setAiScoreMatchCellValues(title: awayInfoKeyArr[indexPath.row], homeValue: homeInfoValueArr[indexPath.row], awayValue: awayInfoValueArr[indexPath.row])
            return cell
        case 1:
            let cell = matchesTV.dequeueReusableCell(withIdentifier: "MatchInfoTableCell", for: indexPath) as! MatchInfoTableCell
            cell.titleLBL.text = infoKeyArr[indexPath.row].replacingOccurrences(of: "_", with: " ", options: .regularExpression, range: nil).capitalized.localized
            cell.valueLBL.text = infoValueArr[indexPath.row]
            return cell
        case 2:
            let cell = matchesTV.dequeueReusableCell(withIdentifier: "OddsTableCell", for: indexPath) as! OddsTableCell
            cell.configure(model: match.odds.oddsInit, _index: indexPath.row)
            return cell
        default:
            let cell = matchesTV.dequeueReusableCell(withIdentifier: "MatchH2HTableCell", for: indexPath) as! MatchH2HTableCell
            cell.leagueImageView.setImage(imageStr: match.leagueInfo.logo, placeholder: Images.league)
            cell.leagueNameLabel.text = selectedLang == .zh ? match.leagueInfo.cnName : match.leagueInfo.enName
            cell.configure(model: matchForH2HArr[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedIndex {
        case 0:
            return 60.0
        case 1:
            return 40.0
        case 2:
            return 150.0
        default:
            return 135.0
        }
    }
}
