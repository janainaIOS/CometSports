//
//  AboutSummaryVC.swift
//  Comet Sports
//
//  Created by iosDev on 11/07/2023.
//

import UIKit

protocol AboutSummaryVCDelegate: AnyObject {
    func aboutTextExpanded(height: CGFloat)
}

class AboutSummaryVC: UIViewController {
    
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var leagueImageIV: UIImageView!
    @IBOutlet weak var leagueNameLBL: UILabel!
    @IBOutlet weak var locationLBL: UILabel!
    @IBOutlet weak var aboutLBL: ExpandableLabel!
    @IBOutlet weak var summaryTV: UITableView!
    
    weak var delegate: AboutSummaryVCDelegate?
    var selectedSegment: MatchDetailSegment = .about //.about .summary
    var matchDeatil = MatchDetail()
    var summeryArray: [ProgressData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setView()
    }
    
    func setView() {
        summaryTV.isHidden = selectedSegment == .about
        aboutView.isHidden = selectedSegment == .summary
        aboutLBL.delegate = self
        aboutLBL.text = matchDeatil.about
        locationLBL.text = matchDeatil.sectionName
        leagueNameLBL.text = matchDeatil.league
        leagueImageIV.setImage(imageStr: matchDeatil.leagueImage, placeholder: UIImage(named: "NoLeague"))
    }
}

// MARK: - TableView Delegates
extension AboutSummaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if summeryArray.count == 0 {
            summaryTV.setEmptyMessage(ErrorMessage.dataEmptyAlert)
        } else {
            summaryTV.restore()
        }
        return summeryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableCell", for: indexPath) as! SummaryTableCell
        cell.setCellValues(model: summeryArray[indexPath.row])
        return cell
    }
}
extension AboutSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = summeryArray[indexPath.row]
        var contentHeight = model.action.progressData(mPlayer: model.mainPlayer, sPlayer: model.subPlayer).2.heightOfString2(width: screenWidth - 150, font: appFontRegular(15))
        contentHeight = contentHeight < 45 ? 45 : contentHeight
        
        switch model.action {
        case "goal":
            return 110 + contentHeight
        case "substitute":
            return 170 + contentHeight
        case "yellow", "red":
            return 55 + contentHeight
        default:
            if model.action.lowercased().range(of: "minutes added") != nil {
                return 60 + contentHeight
            } else {
                return 0
            }
        }
    }
}

extension AboutSummaryVC : ExpandableLabelDelegate {
    func didExpandLabel(_ label: ExpandableLabel) {
        delegate?.aboutTextExpanded(height: aboutLBL.text!.heightOfString2(width: screenWidth - 70, font: appFontRegular(13)))
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        delegate?.aboutTextExpanded(height: aboutLBL.text!.heightOfString2(width: screenWidth - 70, font: appFontRegular(13)))
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {}
    func willCollapseLabel(_ label: ExpandableLabel) {}
}
