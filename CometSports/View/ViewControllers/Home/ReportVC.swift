//
//  ReportVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/02/2024.
//

import UIKit
import GrowingTextView

class ReportVC: UIViewController {

    @IBOutlet weak var topLBL: UILabel!
    @IBOutlet weak var reasonTextView: GrowingTextView!
    @IBOutlet weak var submitBTN: UIButton!
    
    var activityIndicator: ActivityIndicatorHelper!
    var contentId = 0 // post id
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        intialSettings()
    }
    func intialSettings() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        topLBL.text = "Report Post".localized
        submitBTN.setTitle("Submit".localized, for: .normal)
        reasonTextView.placeholder = ErrorMessage.reportEmptyAlert.localized
        reasonTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func validate() -> Bool {
       if reasonTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           Toast.show(message: ErrorMessage.reportEmptyAlert, view: self.view)
           return false
       }
        return true
    }
    
    
    // MARK: - Button Actions
    @IBAction func submitBTNTapped(_ sender: UIButton) {
        if validate() {
            let param: [String: Any] = [
                "post_id": contentId,
                "reason": reasonTextView.text!,
                "flag": "true"
            ]
            
            self.activityIndicator.startAnimaton()
            ForumViewModel.shared.blockUserOrPost(type: .post, parameters: param) { status, errorMsg in
                self.activityIndicator.stopAnimaton()
                if status{
                    self.showAlert1(message: "Thank you for reporting this post. Your report has been successfully received, and we will take the necessary actions after a thorough investigation.") {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    Toast.show(message: errorMsg, view: self.view)
                }
            }
        }
    }
}
