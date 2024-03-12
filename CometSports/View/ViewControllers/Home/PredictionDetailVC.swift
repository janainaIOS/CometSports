//
//  PredictionDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 22/02/2024.
//

import UIKit
import GrowingTextView

class PredictionDetailVC: UIViewController {
    
    @IBOutlet weak var leagueImageIV: UIImageView!
    @IBOutlet weak var leagueLBL: UILabel!
    @IBOutlet weak var homeImageIV: UIImageView!
    @IBOutlet weak var homeLBL: UILabel!
    @IBOutlet weak var awayImageIV: UIImageView!
    @IBOutlet weak var awayLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var winRateLBL: UILabel!
    @IBOutlet weak var ratingLBL: UILabel!
    @IBOutlet weak var userNameLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subTitleLBL: ExpandableLabel!
    @IBOutlet weak var scoreLBL: UILabel!
    @IBOutlet weak var recommentLBL: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLBL: UILabel!
    @IBOutlet weak var commentTV: UITableView!
    @IBOutlet weak var commentTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllLBL: UILabel!
    @IBOutlet weak var commentLBL: UILabel!
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    
    var predictionModel: Prediction?
    var activityIndicator: ActivityIndicatorHelper!
    var allCommentsArray: [Comment] = []
    var commentsArray: [Comment] = []
    var commentSectionId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure(model: predictionModel)
    }
    
    func configure(model: Prediction?) {
        userImageIV.setImage(imageStr: model?.reddragonUser?.profileImg ?? "", placeholder: Images.user)
        userNameLBL.text = model?.reddragonUser?.fullName?.capitalized ?? "Unknown".localized
        winRateLBL.text =  "Win Rate".localized + " \(model?.reddragonUser?.predictionSuccessRate ?? 0)%"
        
        leagueImageIV.setImage(imageStr: model?.match?.competetionDetails?.logo ?? "", placeholder: Images.league)
        leagueLBL.text = selectedLang == .en ? model?.match?.competetionDetails?.name : model?.match?.competetionDetails?.nameZhn
        homeImageIV.setImage(imageStr: model?.match?.homeTeamDetail?.logo ?? "", placeholder: Images.league)
        awayImageIV.setImage(imageStr: model?.match?.awayTeamDetail?.logo ?? "", placeholder: Images.league)
        homeLBL.text = selectedLang == .en ? model?.match?.homeTeamDetail?.name : model?.match?.homeTeamDetail?.nameZhn
        awayLBL.text = selectedLang == .en ? model?.match?.awayTeamDetail?.name : model?.match?.awayTeamDetail?.nameZhn
        dateLBL.text = model?.match?.matchTime?.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssa, outputFormat: dateFormat.ddMMyyyy2)
        timeLBL.text = model?.match?.matchTime?.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssa, outputFormat: dateFormat.Hmma)
        titleLBL.text = model?.title
        subTitleLBL.text = model?.comments
        commentSectionId = "cometSportPredict_\(predictionModel?.id ?? 0)"
        commentLBL.text = "Comments".localized
        viewAllLBL.text = "View All".localized
        commentTextView.placeholder = "Type a message".localized
        scoreLBL.text = "\(model?.match?.homeScores?.score ?? 0) : \(model?.match?.awayScores?.score ?? 0)"
        ratingLBL.text = model?.reddragonUser?.rating
        if let result = model?.isSuccess {
            resultView.backgroundColor = model?.isSuccess == 1 ? .baseColor : .base2Color
            resultLBL.text = model?.isSuccess == 1 ? "Win" : "Lose"
        } else {
            resultView.backgroundColor = .gray1
            resultLBL.text = "Pending"
        }
        resultLBL.text = resultLBL.text!.localized
        let predictTeam = model?.predictedTeam == "1" ? "Draw".localized : (model?.predictedTeam == "2" ? homeLBL.text : awayLBL.text)
        if (model?.type ?? "").contains("over") {
            let goalValue = model?.goals ?? 0
            recommentLBL.text = "\("Recommended".localized) \("Goals".localized) \(model?.predictedType?.localized.capitalized ?? "") \(goalValue < 0 ? "" : "+") \(goalValue)"
        } else {
            recommentLBL.text = "\("Recommended".localized) \(model?.type?.localized.capitalized ?? "") \(predictTeam?.localized ?? "")"
        }
        
        if let user = UserDefaults.standard.user {
            getCommentList()
        }
    }
    
    func initialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        commentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 0)
        nibInitialization()
    }
    
    func nibInitialization() {
        commentTV.register("CommentTableCell")
        commentTV.register("CommentSentTableCell")
    }
    
    func getCommentList() {
        
        CommentVM.shared.getComments(id: commentSectionId) { comments, status, message in
            self.activityIndicator.stopAnimaton()
            self.allCommentsArray = comments.reversed() // for next page
            self.commentsArray = Array(comments.prefix(2)).reversed() // show max 2 comments only
            self.commentTV.reloadData()
            if status {
                
            } else {
                Toast.show(message: message, view: self.view)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func commentBNTapped(_ sender: UIButton) {
        if let user = UserDefaults.standard.user {
            let nextVC = Storyboards.home.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
            nextVC.commentSectionId = self.commentSectionId
            nextVC.commentsArray = self.allCommentsArray
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            self.showAlert2(title: "Login / Sign Up".localized, message: ErrorMessage.loginAlert) {
                /// Show login page to login/register new user
                self.presentViewController(LoginVC.self, storyboard: Storyboards.login) { vc in
                    vc.delegate = self
                }
            }
        }
    }
}

// MARK: - TableView Delegates
extension PredictionDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentTVHeightConstraint.constant = CGFloat(commentsArray.count * 100)
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableCell", for: indexPath) as! CommentTableCell
        cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row)
        return cell
    }
}

extension PredictionDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Custom Delegate
extension PredictionDetailVC: LoginVCDelegate {
    func viewControllerDismissed() {
        getCommentList()
    }
}
