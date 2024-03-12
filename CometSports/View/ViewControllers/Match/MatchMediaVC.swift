//
//  MatchMediaVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/07/2023.
//

import UIKit

class MatchMediaVC: UIViewController {

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
        let nib = UINib(nibName: "MediaTableCell", bundle: nil)
        listTV?.register(nib, forCellReuseIdentifier: "MediaTableCell")
    }
}

// MARK: - TableView Delegates
extension MatchMediaVC: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchDeatil.medias.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.mediaEmptyAlert)
        } else {
            tableView.restore()
        }
        return matchDeatil.medias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTableCell", for: indexPath) as! MediaTableCell
        cell.setMediaCellValues(model: matchDeatil.medias[indexPath.row])
        return cell
    }
}
extension MatchMediaVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "MediaDetailVC") as! MediaDetailVC
        nextVC.model = matchDeatil.medias[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
