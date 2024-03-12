//
//  MatchEventVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/07/2023.
//

import UIKit

class MatchEventVC: UIViewController {
    
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var awayView: UIView!
    @IBOutlet weak var homeIconIV: UIImageView!
    @IBOutlet weak var awayIconIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var homeBTN: UIButton!
    @IBOutlet weak var awayBTN: UIButton!
    
    var matchDeatil = MatchDetail()
    var homeSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    override func viewDidAppear(_ animated: Bool) {
        initialSettings()
    }
    
    func nibInitialization() {
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
        listTV.reloadData()
    }
    
    // MARK: - Button Actions
    
    @IBAction func homeSegmentBTNTapped(_ sender: UIButton) {
        homeSelected = sender.tag == 1
        initialSettings()
    }
}

// MARK: - TableView Delegates
extension MatchEventVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (homeSelected ? matchDeatil.homeEvents.count : matchDeatil.awayEvents.count) == 0 {
            tableView.setEmptyMessage(ErrorMessage.matchesEmptyAlert)
        } else {
            tableView.restore()
        }
        return homeSelected ? matchDeatil.homeEvents.count : matchDeatil.awayEvents.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeSelected ? matchDeatil.homeEvents[section].matches.count : matchDeatil.awayEvents[section].matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableCell", for: indexPath) as! EventTableCell
        cell.setCellValues(model:  homeSelected ? matchDeatil.homeEvents[indexPath.section].matches[indexPath.row] : matchDeatil.awayEvents[indexPath.section].matches[indexPath.row])
        return cell
    }
}
extension MatchEventVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "TableHeaderCell") as! TableHeaderCell
        headerView.titleLBL.text = homeSelected ? matchDeatil.homeEvents[section].league : matchDeatil.awayEvents[section].league
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
