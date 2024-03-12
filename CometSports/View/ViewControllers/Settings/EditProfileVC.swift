//
//  EditProfileVC.swift
//  Comet Sports
//
//  Created by iosDev on 13/02/2024.
//

import UIKit

class EditProfileVC: UIViewController {
    
    @IBOutlet weak var headerLBL: UILabel!
    @IBOutlet weak var userImageIV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var saveBTN: UIButton!
    
    var activityIndicator: ActivityIndicatorHelper!
    var profileImageData: Data? = nil
    var imageName = ""
    var imageUrl = ""
    var imageID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        applyLocalization()
    }
    
    func configure() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        
        if let user = UserDefaults.standard.user {
            userImageIV.setImage(imageStr: user.image, placeholder: Images.user)
            imageUrl = user.image
            nameTF.text = user.fullName
        }
    }
    
    func applyLocalization()  {
        headerLBL.text = "Edit Profile".localized
        saveBTN.setTitle("Save".localized, for: .normal)
        nameTF.attributedPlaceholder = NSAttributedString(string: "Full name".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func validate() -> Bool {
        if imageName == "" && imageUrl == "" {
            Toast.show(message: ErrorMessage.profilepicEmptyAlert, view: self.view)
            return false
        } else if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.nameEmptyAlert, view: self.view)
            return false
        }
        return true
    }
    
    func editProfileProcess() {
        let param: [String: Any] = [
            "full_name": nameTF.text!,
            "img_id": imageID
        ]
        activityIndicator.startAnimaton()
        SettingsViewModel.shared.updateUser(parameters: param) { status, message in
            self.activityIndicator.stopAnimaton()
            if status {
                Toast.show(message: ErrorMessage.profileUpdateSuccess, view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                Toast.show(message: message, view: self.view)
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func imageBTNTapped(_ sender: UIButton) {
        showNewImageActionSheet(sourceView: userImageIV)
    }
    
    @IBAction func saveBTNTapped(_ sender: UIButton) {
        view.endEditing(true)
        if validate() {
            if let imageData = profileImageData {
                SettingsViewModel.shared.uploadImage(imageData: imageData, imageName: imageName) { model, status, message  in
                    self.imageUrl = model?.profileImage ?? ""
                    self.imageID = model?.id ?? 0
                    self.editProfileProcess()
                }
            } else {
                self.editProfileProcess()
            }
        }
    }
    
}

//MARK: - ImagePicker Delegate
extension EditProfileVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() {
    }
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        userImageIV.image = image
        self.imageName = imageName
        profileImageData = image.jpegData(compressionQuality: 0.7) ?? Data()
    }
}
