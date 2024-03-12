//
//  MatchLineupVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/07/2023.
//

import UIKit

class MatchLineupVC: UIViewController {
    
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var awayView: UIView!
    @IBOutlet weak var homeIconIV: UIImageView!
    @IBOutlet weak var awayIconIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var homeBTN: UIButton!
    @IBOutlet weak var awayBTN: UIButton!
    @IBOutlet weak var lineupLBL: UILabel!
    @IBOutlet weak var goalPlayerBTN: UIButton!
    @IBOutlet weak var dStackView: UIStackView!
    @IBOutlet weak var mStackView: UIStackView!
    @IBOutlet weak var fStackView: UIStackView!
    @IBOutlet weak var dStackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mStackWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fStackWidthConstraint: NSLayoutConstraint!
    
    var matchDeatil = MatchDetail()
    var homeSelected = true
    var mainSectionData: [[String]] = []
    var subSectionData: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    override func viewDidAppear(_ animated: Bool) {
        initialSettings()
    }
    
    func nibInitialization() {
        
        dStackView.removeConstraint(dStackWidthConstraint)
        mStackView.removeConstraint(mStackWidthConstraint)
        fStackView.removeConstraint(fStackWidthConstraint)
        let nib = UINib(nibName: "TableHeaderCell", bundle: nil)
        listTV?.register(nib, forCellReuseIdentifier: "TableHeaderCell")
    }
    
    func initialSettings() {
        
        homeView.backgroundColor = homeSelected ? .baseColor : .gray1
        awayView.backgroundColor = homeSelected ? .gray1 : .baseColor
        homeIconIV.setImage(imageStr: matchDeatil.homeImage, placeholder: UIImage(named: "NoLeague"))
        awayIconIV.setImage(imageStr: matchDeatil.awayImage, placeholder: UIImage(named: "NoLeague"))
        homeLBL.text = matchDeatil.homeTeam
        awayLBL.text = matchDeatil.awayTeam
        mainSectionData = (homeSelected ? matchDeatil.homeLineup : matchDeatil.awayLineup).playerMain
        subSectionData = (homeSelected ? matchDeatil.homeLineup : matchDeatil.awayLineup).playerSubstitute
        goalPlayerBTN.isHidden = mainSectionData.count == 0
        listTV.reloadData()
        
        // Lineup view
        for infoData in (homeSelected ? matchDeatil.homeLineup : matchDeatil.awayLineup).info {
            if infoData.key == "Lineups formation" {
                lineupLBL.text = infoData.value
            }
        }
        var dPlayerArray: [[String]] = []
        var mPlayerArray: [[String]] = []
        var fPlayerArray: [[String]] = []
        
        for player in mainSectionData {
            if player[4] == "D" {
                dPlayerArray.append(player)
            } else if player[4] == "M" {
                mPlayerArray.append(player)
            } else if player[4] == "F" {
                fPlayerArray.append(player)
            } else if player[4] == "G" {
                goalPlayerBTN.setTitle(player[0], for: .normal)
            }
        }
        
        
        dStackView.removeFullyAllArrangedSubviews()
        mStackView.removeFullyAllArrangedSubviews()
        fStackView.removeFullyAllArrangedSubviews()
        
        for player in dPlayerArray {
            let vieW = getPlayerView(num: "\(player[0])")
            dStackView.addArrangedSubview(vieW)
            
        }
        for player in mPlayerArray {
            let vieW = getPlayerView(num: "\(player[0])")
            mStackView.addArrangedSubview(vieW)
        }
        for player in fPlayerArray {
            let vieW = getPlayerView(num: "\(player[0])")
            fStackView.addArrangedSubview(vieW)
        }
    }
    
    func getPlayerView(num: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "TshirtYellow"), for: .normal)
        button.setTitle(num, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = appFontRegular(9)
        button.isUserInteractionEnabled = false
        return button
    }
    
    // MARK: - Button Actions
    
    @IBAction func homeSegmentBTNTapped(_ sender: UIButton) {
        homeSelected = sender.tag == 1
        initialSettings()
    }
}

// MARK: - TableView Delegates
extension MatchLineupVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = (mainSectionData.count == 0 && subSectionData.count == 0) ? 0 : 2
        if sectionCount == 0 {
            self.listTV.setEmptyMessage(ErrorMessage.dataEmptyAlert)
        } else {
            self.listTV.restore()
        }
        return sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? mainSectionData.count : subSectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LineupTableCell", for: indexPath) as! LineupTableCell
        cell.setCellValues(dataArray: indexPath.section == 0 ? mainSectionData[indexPath.row] : subSectionData[indexPath.row])
        return cell
    }
}
extension MatchLineupVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "TableHeaderCell") as! TableHeaderCell
        headerView.titleLBL.text = section == 0 ? "Main Player".localized : "Substitutes".localized
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
