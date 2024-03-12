//
//  SettingsVC.swift
//  Comet Sports
//
//  Created by iosDev on 27/05/2023.
//

import UIKit

enum SettingsList: String, CaseIterable {
    case account  = "Account"
    case edit     = "Edit Profile"
    case language = "Language"
    case privacy  = "Privacy Policy"
    case rate     = "Rate this app"
    case contact  = "Contact Us"
    case delete   = "Delete Account"
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var listTV: UITableView!
    @IBOutlet weak var logoutBTN: UIButton!
    
    var activityIndicator: ActivityIndicatorHelper!
    var settingArray: [SettingsList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        listTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0);
    }
    
    func configure() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        userImageIV.setImage(imageStr: "", placeholder: Images.user)
        nameLBL.text = "Guest User".localized
        logoutBTN.isHidden = true
        settingArray = [.account, .language, .privacy, .rate, .contact]
        if let user = UserDefaults.standard.user {
            
            settingArray = [.edit, .language, .privacy, .rate, .contact, .delete]
            logoutBTN.isHidden = false
            userImageIV.setImage(imageStr: user.image, placeholder: Images.user)
            nameLBL.text = user.fullName
        }
        listTV.reloadData()
    }
    
    func rateApp() {
        guard let url = URL(string : URLs.appReview) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: { status in
                if status {
                    
                } else {
                    Toast.show(message: ErrorMessage.somethingWentWrong, view: self.view)
                }
            })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func deleteAccount() {
        self.showAlert2(message: "Are you sure you want to delete?".localized) {
            self.activityIndicator.startAnimaton()
            SettingsViewModel.shared.deleteAccount { status, errorMsg in
                self.activityIndicator.stopAnimaton()
                if status {
                    UserDefaults.standard.clearSpecifiedItems()
                    self.configure()
                } else {
                    Toast.show(message: errorMsg, view: self.view)
                }
                self.listTV.reloadData()
            }
        }
    }
    
    @IBAction func logoutBTNTapped(_ sender: UIButton) {
        self.showAlert2(message: "Are you sure you want to logout?".localized) {
            UserDefaults.standard.clearSpecifiedItems()
            self.configure()
        }
    }
}

// MARK: - TableView Delegates
extension SettingsVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        cell.setCellValues(type: settingArray[indexPath.row])
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = settingArray[indexPath.row]
        switch type {
        case .account:
            self.showAlert2(title: "Login / Sign Up".localized, message: ErrorMessage.loginAlert.localized) {
                /// Show login page to login/register new user
                self.presentViewController(LoginVC.self, storyboard: Storyboards.login) { vc in
                    vc.delegate = self
                }
            }
        case .edit:
            let nextVC = Storyboards.setting.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .language:
            let nextVC = Storyboards.setting.instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .privacy:
            guard let url = URL(string: URLs.privacyPolicy) else { return }
            UIApplication.shared.open(url)
        case .contact:
            guard let url = URL(string: URLs.contactUs) else { return }
            UIApplication.shared.open(url)
        case .rate:
            rateApp()
        case .delete:
            deleteAccount()
        }
    }
}

// MARK: - Custom Delegate
extension SettingsVC: LoginVCDelegate {
    func viewControllerDismissed() {
        configure()
    }
}
