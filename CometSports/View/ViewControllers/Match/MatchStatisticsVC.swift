//
//  MatchStatisticsVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/07/2023.
//

import UIKit

class MatchStatisticsVC: UIViewController {

    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var matchStatusLBL: UILabel!
    
    var matchDeatil = MatchDetail()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        nibInitialization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Refresh for localization
        matchStatusLBL.text = "Match Status".localized
        listTV.reloadData()
    }
    
    func nibInitialization() {
        let nib = UINib(nibName: "StatisticsTableCell", bundle: nil)
        listTV?.register(nib, forCellReuseIdentifier: "StatisticsTableCell")
    }
}

// MARK: - TableView Delegates
extension MatchStatisticsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyArray = matchDeatil.statistics.first?.data ?? []
        if keyArray.count == 0 {
            self.listTV.setEmptyMessage(ErrorMessage.dataEmptyAlert)
        } else {
            self.listTV.restore()
        }
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticsTableCell", for: indexPath) as! StatisticsTableCell
        let keyArray = matchDeatil.statistics.first?.data ?? []
        cell.setCellValues(model: keyArray[indexPath.row])
        return cell
    }
}

extension MatchStatisticsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
