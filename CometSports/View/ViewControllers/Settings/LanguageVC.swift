//
//  LanguageVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import UIKit

enum LanguageList: String, CaseIterable {
    case en = "English"
    case zh = "中文" //cn
}

class LanguageVC: UIViewController {
    
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var headerLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Refresh for localization
        headerLBL.text = "Language".localized
        listTV.reloadData()
    }
    
    // MARK: - Methods
    
    func resetLanguage(lang: LanguageList) {
        selectedLang = lang
        UserDefaults.standard.appLanguage = selectedLang == .zh ? "zh" : "en"
        headerLBL.text = "Language".localized
        listTV.reloadData()
    }
}

// MARK: - TableView Delegates
extension LanguageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LanguageList.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageTableCell", for: indexPath) as! LanguageTableCell
        cell.setCellValues(selected: selectedLang.rawValue == LanguageList.allCases[indexPath.row].rawValue, title: LanguageList.allCases[indexPath.row].rawValue)
        return cell
    }
}
extension LanguageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        resetLanguage(lang: LanguageList.allCases[indexPath.row])
    }
}
