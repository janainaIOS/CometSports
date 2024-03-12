//
//  MatchStandingsVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/07/2023.
//

import UIKit

class MatchStandingsVC: UIViewController {
    
    @IBOutlet weak var listTV: UITableView!
    
    var matchDeatil = MatchDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Refresh for localization
        listTV.reloadData()
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "CollectionTableCell", bundle: nil)
        let nib2 = UINib(nibName: "TableHeaderCell", bundle: nil)
        listTV?.register(nib, forCellReuseIdentifier: "CollectionTableCell")
        listTV?.register(nib2, forCellReuseIdentifier: "TableHeaderCell")
    }
}

// MARK: - TableView Delegates
extension MatchStandingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if matchDeatil.standings.count == 0 {
            self.listTV.setEmptyMessage(ErrorMessage.dataEmptyAlert)
        } else {
            self.listTV.restore()
        }
        return matchDeatil.standings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchDeatil.standings[section].tableData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableCell", for: indexPath) as! CollectionTableCell
        if indexPath.row == 0 {// for table heading
            cell.setCellValues(array:  matchDeatil.standings[indexPath.section].tableHeader, isHeader: true)
        } else {
            cell.setCellValues(array:  matchDeatil.standings[indexPath.section].tableData[indexPath.row - 1], isHeader: false)
        }
        return cell
    }
}
extension MatchStandingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "TableHeaderCell") as! TableHeaderCell
        headerView.titleLBL.text = matchDeatil.standings[section].name
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
