//
//  MatchesVC.swift
//  Comet Sports
//
//  Created by iosDev on 08/07/2023.
//

import UIKit
import FSCalendar

class MatchesVC: UIViewController {
    
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTF: UITextField!
    
    var activityIndicator: ActivityIndicatorHelper!
    var calenderDatesArray: [String] = []
    var allMatchArray: [MatchList] = []
    var matchArray: [MatchList] = []
    var selectedDate = Date() //yyyyMMdd
    var dayOffset = 0 // 0 -> today, -1 -> yesterday, -2 -> last two days .... max = -7
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    // MARK: - Methods
    func initialSettings() {
        nibInitialization()
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        calender.appearance.headerTitleFont = appFontSemiBold(17)
        calender.appearance.subtitleFont = appFontMedium(16)
        calender.rowHeight = 40
    }
    
    func nibInitialization() {
        let nib2 = UINib(nibName: "MatchesTableCell", bundle: nil)
        listTV?.register(nib2, forCellReuseIdentifier: "MatchesTableCell")
    }
    
    func configureView() {
        calender.locale = Locale(identifier: selectedLang == .en ? "en" : "zh-Hans")
        headerLBL.text = "Match Score".localized
        searchTF.attributedPlaceholder = NSAttributedString(string: "Search".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        getMatchList()
    }
    
    func getMatchList() {
        activityIndicator.startAnimaton()
        HomeViewModel.shared.getFootballMatches(days: dayOffset) { matches,status,errorMsg  in
            self.activityIndicator.stopAnimaton()
            if status {
                self.matchArray = matches
                self.allMatchArray = matches
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
            self.listTV.reloadData()
        }
    }
    
    func searchData(text: String) {
        if text.count > 1 {
            
            matchArray = allMatchArray
            matchArray = matchArray.filter({(item: MatchList) -> Bool in
                if item.homeInfo.cnName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.homeInfo.enName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.awayInfo.cnName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.awayInfo.enName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.leagueInfo.cnName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                if item.leagueInfo.enName.lowercased().range(of: text.lowercased()) != nil {
                    return true
                }
                return false
            })
        } else {
            matchArray = allMatchArray
        }
        listTV.reloadData()
    }
    
    
    // MARK: - Button Action
    
    @IBAction func searchBTNTapped(_ sender: UIButton) {
        searchTF.endEditing(true)
        searchData(text: searchTF.text!)
    }
}

// MARK: - FSCalendar Delegates
extension MatchesVC: FSCalendarDataSource {
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date().findDate(duration: -7)
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().findDate(duration: 7)
    }
}

extension MatchesVC: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        //News list
        dayOffset = date.numOfDaysFromToday() // get day offset for news api
        //dayOffset = (dayOffset > 7 || dayOffset < -7) ? 0 : dayOffset
        if date > Date() {
            dayOffset = dayOffset + 1
        }
        //Match list
        getMatchList()
    }
}

// MARK: - TableView Delegates
extension MatchesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableHeightConstraint.constant = CGFloat(matchArray.count * 130) + 250
        
        if self.matchArray.count == 0 {
            self.listTV.setEmptyMessage(ErrorMessage.matchesEmptyAlert)
        } else {
            self.listTV.restore()
        }
        return matchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchesTableCell", for: indexPath) as! MatchesTableCell
        cell.setCellValues(model: matchArray[indexPath.row])
        return cell
    }
}

extension MatchesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "AiScoreMatchDetailVC") as! AiScoreMatchDetailVC
        nextVC.match = matchArray[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - TextField Delegate
extension MatchesVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let searchText = text.replacingCharacters(in: textRange,with: string)
            print("searchText  \(searchText)")
         searchData(text: searchText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchData(text: searchTF.text!)
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        searchData(text: searchTF.text!)
        return true
    }
}

