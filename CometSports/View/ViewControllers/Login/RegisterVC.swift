//
//  RegisterVC.swift
//  Comet Sports
//
//  Created by iosDev on 13/02/2024.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var signUpBTN: UIButton!
    @IBOutlet weak var bottomLBL: UILabel!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var checkBTN: UIButton!
    
    var activityIndicator: ActivityIndicatorHelper!
    var profileImageData: Data? = nil
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        checkBTN.isSelected = false
        activityIndicator = ActivityIndicatorHelper(view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalization()
    }
    
    func applyLocalization()  {
        headerLBL.text = "Sign Up".localized
        signUpBTN.setTitle("Sign Up".localized, for: .normal)
        bottomLBL.text = "Already have an account?".localized
        signInBTN.setTitle("Sign In".localized, for: .normal)
        let termsFormatedText = NSMutableAttributedString()
        termsFormatedText.regularColorText("By signing up you agree to our Terms of use and Privacy Policy".localized, size: 13, color: .lightGray)
        termsFormatedText.addLink(textToFind: "Terms of use".localized, linkURL: URLs.terms)
        termsFormatedText.addLink(textToFind: "Privacy Policy".localized, linkURL: URLs.privacyPolicy)
        termsFormatedText.changeFont(textToFind: "Terms of use".localized, font: appFontMedium(15))
        termsFormatedText.changeFont(textToFind: "Privacy Policy".localized, font: appFontMedium(15))
        termsTextView.attributedText = termsFormatedText
        nameTF.attributedPlaceholder = NSAttributedString(string: "Full name".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        emailTF.attributedPlaceholder = NSAttributedString(string: "Email".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func validate() -> Bool {
        if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.nameEmptyAlert, view: self.view)
            return false
        } else if emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
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
        } else if !checkBTN.isSelected {
            Toast.show(message: ErrorMessage.termsAlert, view: self.view)
           return false
       }
        return true
    }
    
    // MARK: - Button Actions
    @IBAction func checkBTNTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func signUpBTNTapped(_ sender: UIButton) {
        view.endEditing(true)
        if validate() {
            activityIndicator.startAnimaton()
            let param: [String: Any] = [
                "full_name": nameTF.text!,
                "email": emailTF.text!,
                "password": passwordTF.text!
            ]
           
           LoginViewModel.shared.register(parameters: param) { status, message in
               self.activityIndicator.stopAnimaton()
                if status {
                    self.showAlert1(message: ErrorMessage.signUpSuccess) {
                        self.dismiss(animated: true)
                    }
                } else {
                     Toast.show(message: message, view: self.view)
                }
            }
        }
    }
}
