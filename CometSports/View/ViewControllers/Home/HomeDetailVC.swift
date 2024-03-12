//
//  HomeDetailVC.swift
//  Comet Sports
//
//  Created by iosDev on 08/07/2023.
//

import UIKit
import SwiftSoup
import GrowingTextView

class HomeDetailVC: UIViewController {
    
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var dateLBL: UILabel!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var subTitleLBL: ExpandableLabel!
    @IBOutlet weak var commentTV: UITableView!
    @IBOutlet weak var commentTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewAllLBL: UILabel!
    @IBOutlet weak var commentLBL: UILabel!
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    var activityIndicator: ActivityIndicatorHelper!
    var allCommentsArray: [Comment] = []
    var commentsArray: [Comment] = []
    var commentSectionId = ""
    var newsId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        commentLBL.text = "Comments".localized
        viewAllLBL.text = "View All".localized
        commentSectionId = "cometSportNews_\(newsId)"
        commentTextView.placeholder = "Type a message".localized
        if let user = UserDefaults.standard.user {
            getCommentList()
        }
    }
    
    // MARK: - Methods
    func getNewsDetail() {
        activityIndicator.startAnimaton()
        HomeViewModel.shared.getnewsDetail(newsId: newsId) { news,status,errorMsg  in
            self.activityIndicator.stopAnimaton()
            if status {
                self.setValue(model: news)
            } else {
                Toast.show(message: errorMsg, view: self.view)
            }
        }
    }
    
    func initialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        commentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 0)
        nibInitialization()
        getNewsDetail()
    }
    
    func nibInitialization() {
        commentTV.register("CommentTableCell")
        commentTV.register("CommentSentTableCell")
    }
    
    func setValue(model : News) {
        let dateText = model.date.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssTimeZone, outputFormat: dateFormat.dd)
        let monthText = model.date.formatDate(inputFormat: dateFormat.yyyyMMddHHmmssTimeZone, outputFormat: dateFormat.MMM).uppercased()
        dateLBL.text = "\(dateText)\n\(monthText)"
        imageIV.setImage(imageStr: model.path)
        
        if let attributedText = model.title.attributedHtmlString {
            titleLBL.text = attributedText.string
        }
        if let attributedText = model.content.attributedHtmlString {
            subTitleLBL.text = attributedText.string
        }
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
            nextVC.contentTitle = " - \(titleLBL.text ?? "")"
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
extension HomeDetailVC: UITableViewDataSource {
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

extension HomeDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - Custom Delegate
extension HomeDetailVC: LoginVCDelegate {
    func viewControllerDismissed() {
        getCommentList()
    }
}
