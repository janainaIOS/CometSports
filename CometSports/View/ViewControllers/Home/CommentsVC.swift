//
//  CommentsVC.swift
//  Comet Sports
//
//  Created by iosDev on 23/02/2024.
//

import UIKit
import GrowingTextView

class CommentsVC: UIViewController {

    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextView: GrowingTextView!
    
    var activityIndicator: ActivityIndicatorHelper!
    var commentsArray: [Comment] = []
    var contentTitle = ""
    var commentSectionId = ""
    var pushFromNews = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialSettings()
    }

    override func viewDidLayoutSubviews() {
        commentTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if commentsArray.count > 0 {
            let indexPosition = IndexPath(row: commentsArray.count - 1, section: 0)
            self.commentTableView.scrollToRow(at: indexPosition, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    func initialSettings() {
        nibInitialization()
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let formatedText = NSMutableAttributedString()
        formatedText.semiBold("Comments".localized, size: 16).regular(contentTitle, size: 16)
        headerLBL.attributedText = formatedText
        commentTextView.placeholder = "Type a message".localized
    }
    
    func nibInitialization() {
        commentTableView.register("CommentTableCell")
        commentTableView.register("CommentSentTableCell")
    }
    
    func getCommentList() {
        
        activityIndicator.startAnimaton()
        CommentVM.shared.getComments(id: commentSectionId) { comments, status, message in
            self.activityIndicator.stopAnimaton()
            self.commentsArray = comments.reversed()
            self.commentTableView.reloadData()
            if status {
                if self.commentsArray.count > 0 {
                    let indexPosition = IndexPath(row: self.commentsArray.count - 1, section: 0)
                    self.commentTableView.scrollToRow(at: indexPosition, at: UITableView.ScrollPosition.bottom, animated: true)
                }
            } else {
                Toast.show(message: message, view: self.view)
            }
        }
    }
    
    // MARK: - Button Actions
    @IBAction func sendBTNTapped(_ sender: UIButton) {
        
        guard !commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        commentTextView.endEditing(true)
        activityIndicator.startAnimaton()
        let param: [String: Any] = [
            "comment": commentTextView.text!,
            "comment_section_id": commentSectionId
        ]
        commentTextView.text = ""
        CommentVM.shared.addComment(parameters: param) { status, message in
            self.activityIndicator.stopAnimaton()
            if status {
                self.getCommentList()
            } else {
                Toast.show(message: message, view: self.view)
            }
        }
    }
    
    @objc func deleteCommentBTNTapped(sender: UIButton) {
        self.showAlert2(message: "Are you sure you want to delete?") {
            CommentVM.shared.deleteComment(commentId: self.commentsArray[sender.tag].id) { status, message in
                self.activityIndicator.stopAnimaton()
                if status {
                    self.commentsArray.remove(at: sender.tag)
                    self.commentTableView.reloadData()
                } else {
                    Toast.show(message: message, view: self.view)
                }
            }
        }
    }
}

// MARK: - TableView Delegates
extension CommentsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentsArray.count == 0 {
            tableView.setEmptyMessage(ErrorMessage.commentListEmptyAlert)
        } else {
            tableView.restore()
        }
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableCell", for: indexPath) as! CommentTableCell
         cell.configureComments(model: commentsArray[indexPath.row], _index: indexPath.row, listView: true)
        cell.deleteButton?.addTarget(self, action: #selector(deleteCommentBTNTapped(sender:)), for: .touchUpInside)
        return cell
    }
}

extension CommentsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
