//
//  MatchDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 08/07/2023.
//

import UIKit

enum MatchDetailSegment: String, CaseIterable {
    case about = "About"
    case summary = "Summary"
    case statistic = "Statistics"
    case lineup = "Lineup"
    case standings = "Standings"
    case events = "Events"
    case media = "Media"
}

class MatchDetailVC: UIViewController {
    
    @IBOutlet weak var leagueImageIV: UIImageView!
    @IBOutlet weak var leagueNameLBL: UILabel!
    @IBOutlet weak var homeIconIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var statusLBL: UILabel!
    @IBOutlet weak var sectionLBL: UILabel!
    @IBOutlet weak var awayIconIV: UIImageView!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var segmentCV: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLBL: UILabel!
    
    var activityIndicator: ActivityIndicatorHelper!
    var slugString = ""
    var leagueImage = ""
    var selectedSegment: MatchDetailSegment = .about
    var selectedStanding = Standings()
    var matchDeatil = MatchDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        initialSettings()
    }
    
    // MARK: - Methods
    func initialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        nibInitialization()
        headerLBL.text = "Match Detail".localized
        getMatchDetail()
    }
    
    func nibInitialization() {
        segmentCV.register("SegmentsCollectionCell")
    }
    
    func getMatchDetail() {
        activityIndicator.startAnimaton()
        HomeViewModel.shared.getMatchDetail(slug: slugString) { getMatchDetail,status,errorMsg  in
            self.activityIndicator.stopAnimaton()
            if status {
                self.matchDeatil = getMatchDetail
                self.matchDeatil.leagueImage = self.leagueImage
                self.leagueNameLBL.text = self.matchDeatil.league
                self.leagueImageIV.setImage(imageStr: self.matchDeatil.leagueImage, placeholder: UIImage(named: "NoLeague"))
                self.homeLBL.text = self.matchDeatil.homeTeam
                self.awayLBL.text = self.matchDeatil.awayTeam
                self.scoreLBL.text = "\(self.matchDeatil.homeScore) : \(self.matchDeatil.awayScore)"
                self.statusLBL.borderColor = self.matchDeatil.matchState == "" ? .clear : .white
                self.statusLBL.text = " \(self.matchDeatil.matchState.getMatchState()) "
                self.sectionLBL.text = self.matchDeatil.sectionName
                self.homeIconIV.setImage(imageStr: self.matchDeatil.homeImage, placeholder: UIImage(named: "NoLeague"))
                self.awayIconIV.setImage(imageStr: self.matchDeatil.awayImage, placeholder: UIImage(named: "NoLeague"))
                self.selectedStanding = self.matchDeatil.standings.first ?? Standings()
                self.setContainerView()
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
        }
    }
    
    
    func setContainerView() {
        var containerHeight = 500
        switch selectedSegment {
            
        case .statistic:
            ViewEmbedder.embed(withIdentifier: "MatchStatisticsVC", storyboard: Storyboards.home
                               , parent: self, container: containerView) { vc in
                let vc = vc as! MatchStatisticsVC
                vc.matchDeatil = self.matchDeatil
            }
            containerHeight = ((matchDeatil.statistics.first?.data.count ?? 0) * 70) + 110
            
        case .lineup:
            ViewEmbedder.embed(withIdentifier: "MatchLineupVC", storyboard: Storyboards.home
                               , parent: self, container: containerView) { vc in
                let vc = vc as! MatchLineupVC
                vc.matchDeatil = self.matchDeatil
            }
            let homeDataHeight = (matchDeatil.homeLineup.playerMain.count + matchDeatil.homeLineup.playerSubstitute.count) * 80
            let awayDataHeight = (matchDeatil.awayLineup.playerMain.count + matchDeatil.awayLineup.playerSubstitute.count) * 80
            containerHeight = 600 + max(homeDataHeight, awayDataHeight)
        case .standings:
            ViewEmbedder.embed(withIdentifier: "MatchStandingsVC", storyboard: Storyboards.home
                               , parent: self, container: containerView) { vc in
                let vc = vc as! MatchStandingsVC
                vc.matchDeatil = self.matchDeatil
            }
            var standingHeight = 0
            for standg in matchDeatil.standings {
                standingHeight = standingHeight + (standg.tableData.count * 45) + 50
            }
            containerHeight = standingHeight + 300
        case .events:
            ViewEmbedder.embed(withIdentifier: "MatchEventVC", storyboard: Storyboards.home
                               , parent: self, container: containerView) { vc in
                let vc = vc as! MatchEventVC
                vc.matchDeatil = self.matchDeatil
            }
            var homeEventHeight = 0
            for event in matchDeatil.homeEvents {
                homeEventHeight = homeEventHeight + (event.matches.count * 110) + 50
            }
            var awayEventHeight = 0
            for event in matchDeatil.awayEvents {
                awayEventHeight = awayEventHeight + (event.matches.count * 110) + 80
            }
            containerHeight = max(homeEventHeight, awayEventHeight) + 200
        case .media:
            ViewEmbedder.embed(withIdentifier: "MatchMediaVC", storyboard: Storyboards.home
                               , parent: self, container: containerView) { vc in
                let vc = vc as! MatchMediaVC
                vc.matchDeatil = self.matchDeatil
            }
            containerHeight = matchDeatil.medias.count * 140
        default: //About  Summary
            ViewEmbedder.embed(withIdentifier: "AboutSummaryVC", storyboard: Storyboards.home
                               , parent: self, container: containerView) { vc in
                let vc = vc as! AboutSummaryVC
                vc.matchDeatil = self.matchDeatil
                vc.selectedSegment = self.selectedSegment
                vc.delegate = self
                
                if self.selectedSegment == .summary {
                    // make summary object array
                    var summeryArr: [ProgressData] = []
                    for progress in self.matchDeatil.progress {
                        summeryArr.append(contentsOf: progress.data)
                    }
                    
                    // get image of players from lineup list
                    
                    let allPlayers = self.matchDeatil.homeLineup.playerMain + self.matchDeatil.homeLineup.playerSubstitute + self.matchDeatil.awayLineup.playerMain + self.matchDeatil.awayLineup.playerSubstitute
                    
                    for (indx, summry) in summeryArr.enumerated() {
                        for player in allPlayers {
                            // Remove space and chinese words
                            if summry.mainPlayer.alphabt == player[3].alphabt {
                                summeryArr[indx].mainPlayerImage = player[2]
                            }
                            if summry.subPlayer.alphabt == player[3].alphabt {
                                summeryArr[indx].subPlayerImage = player[2]
                            }
                        }
                    }
                    vc.summeryArray = summeryArr
                    var summryHeight = 0
                    for summery in summeryArr {
                        var contentHeight = Int(summery.action.progressData(mPlayer: summery.mainPlayer, sPlayer: summery.subPlayer).2.heightOfString2(width: screenWidth - 150, font: appFontRegular(15)))
                        contentHeight = contentHeight < 45 ? 45 : contentHeight
                        
                        switch summery.action {
                        case "goal":
                            summryHeight = summryHeight + 110 + contentHeight
                        case "substitute":
                            summryHeight = summryHeight + 170 + contentHeight
                        case "yellow", "red":
                            summryHeight = summryHeight + 55 + contentHeight
                        default:
                            if summery.action.lowercased().range(of: "minutes added") != nil {
                                summryHeight = summryHeight + 60 + contentHeight
                            } else {
                                summryHeight = summryHeight + 0
                            }
                        }
                    }
                    containerHeight = summryHeight + 150
                }
            }
        }
        print("----- containerHeight \(containerHeight)")
        containerHeight = containerHeight < 500 ? 500 : containerHeight
        containerHeightConstraint.constant = CGFloat(containerHeight)
        containerView.layoutSubviews()
    }
}

// MARK: - CollectionView Delegates
extension MatchDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MatchDetailSegment.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SegmentsCollectionCell", for: indexPath) as! SegmentsCollectionCell
        cell.setCellValues(selected: selectedSegment.rawValue == MatchDetailSegment.allCases[indexPath.row].rawValue, title: MatchDetailSegment.allCases[indexPath.row].rawValue)
        return cell
    }
}

extension MatchDetailVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSegment = MatchDetailSegment.allCases[indexPath.row]
        segmentCV.reloadData()
        setContainerView()
    }
}

extension MatchDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let fontSize = selectedSegment.rawValue == MatchDetailSegment.allCases[indexPath.row].rawValue ? 17 : 14
        return CGSize(width: MatchDetailSegment.allCases[indexPath.row].rawValue.localized.size(withAttributes: [NSAttributedString.Key.font : appFontMedium(CGFloat(fontSize))]).width + 40, height: 40)
    }
}

// MARK: - Custom Delegates
extension MatchDetailVC: AboutSummaryVCDelegate {
    func aboutTextExpanded(height: CGFloat) {
        containerHeightConstraint.constant = height + 280
        containerView.layoutSubviews()
    }
}
