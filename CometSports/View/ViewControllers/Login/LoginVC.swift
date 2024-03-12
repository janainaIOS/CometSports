//
//  LoginVC.swift
//  Comet Sports
//
//  Created by iosDev on 10/02/2024.
//

import UIKit

protocol LoginVCDelegate:AnyObject {
    func viewControllerDismissed()
}

class LoginVC: UIViewController {
    
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotBTN: UIButton!
    @IBOutlet weak var loginInBTN: UIButton!
    @IBOutlet weak var signUpBTN: UIButton!
    @IBOutlet weak var bottomLBL: UILabel!
    
    weak var delegate:LoginVCDelegate?
    var activityIndicator: ActivityIndicatorHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.viewControllerDismissed()
    }
    
    func applyLocalization()  {
        headerLBL.text = "Glad to meet you again!".localized
        signUpBTN.setTitle("Sign Up".localized, for: .normal)
        bottomLBL.text = "Don’t have an account?".localized
        loginInBTN.setTitle("Login".localized, for: .normal)
        signUpBTN.setTitle("Sign Up".localized, for: .normal)
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
    }
    
    func validate() -> Bool {
        if emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.emailEmptyAlert, view: self.view)
            return false
        } else if !(emailTF.text?.lowercased().validEmail())! {
            Toast.show(message: ErrorMessage.validEmailAlert, view: self.view)
            return false
        } else if passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.passwordEmptyAlert, view: self.view)
            return false
        } else if !(passwordTF.text?.lowercased().validPassword())! {
            Toast.show(message: ErrorMessage.validPasswordAlert, view: self.view)
            return false
        }
        return true
    }
    
    // MARK: - Button Actions
    @IBAction func forgotBTNTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func signUpBTNTapped(_ sender: UIButton) {
        self.presentViewController(RegisterVC.self, storyboard: Storyboards.login)
    }
    
    @IBAction func loginInBTNTapped(_ sender: UIButton) {
        view.endEditing(true)
        if validate() {
            let param: [String: Any] = [
                "email": emailTF.text!,
                "password": passwordTF.text!
            ]
            activityIndicator.startAnimaton()
            LoginViewModel.shared.login(parameters: param) { status, message in
                self.activityIndicator.stopAnimaton()
                if status {
                    self.dismiss(animated: true)
                } else {
                    Toast.show(message: message, view: self.view)
                }
            }
        }
    }
}
