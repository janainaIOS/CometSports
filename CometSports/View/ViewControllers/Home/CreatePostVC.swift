//
//  CreatePostVC.swift
//  Comet Sports
//
//  Created by iosDev on 26/02/2024.
//

import UIKit
import GrowingTextView

class CreatePostVC: UIViewController {
    
    @IBOutlet weak var zoneImageIV: UIImageView!
    @IBOutlet weak var fanzoneNameTF: DropDown!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var detailTextView: GrowingTextView!
    @IBOutlet weak var publishBTN: UIButton!
    @IBOutlet weak var postImageIV: UIImageView!
    @IBOutlet weak var postImageHeightConstraint: NSLayoutConstraint!
    
    var activityIndicator: ActivityIndicatorHelper!
    var forumUniqId = ""
    var forumArray: [Forum] = []
    var imageData: Data? = nil
    var imageName = ""
    var imageID = 0
    var isForEdit = false
    var postModel: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configure()
    }
    func initialSetting() {
        activityIndicator = ActivityIndicatorHelper(view: self.view)
        getForumList()
    }
    
    func configure() {
        fanzoneNameTF.attributedPlaceholder = NSMutableAttributedString().regularColorText("Select a Fan Zone".localized, size: 14, color: .lightGray)
        titleTF.attributedPlaceholder = NSMutableAttributedString().regularColorText("Post Title".localized, size: 14, color: .lightGray)
        detailTextView.attributedPlaceholder = NSMutableAttributedString().regularColorText("Description".localized, size: 14, color: .lightGray)
        detailTextView.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)
        publishBTN.setTitle(isForEdit ? "Save".localized : "Publish".localized, for: .normal)
        if isForEdit {
            fanzoneNameTF.text = postModel?.forumName
            titleTF.text = postModel?.title
            if let attributedText = postModel?.contentHTML?.attributedHtmlString {
                detailTextView.text = attributedText.string
            }
            if postModel?.postImages?.count ?? 0 > 0 {
                imageID = postModel?.postImages?.first?.id ?? 0
                postImageHeightConstraint.constant = 200
                postImageIV.setImage(imageStr: postModel?.postImages?.first?.url ?? "", placeholder: Images.noImage)
            }
        }
    }
    
    func getForumList() {
        activityIndicator.startAnimaton()
        ForumViewModel.shared.getForums(notJoined: false) { forums, status, errorMsg in
            self.activityIndicator.stopAnimaton()
            self.forumArray = forums
            self.configureFanzoneDropdown()
        }
    }
    
    func configureFanzoneDropdown() {
        if let _index = forumArray.firstIndex(where: { $0.forumUniqueID == forumUniqId }) {
            self.fanzoneNameTF.text = self.forumArray[_index].title
            self.postModel?.forumUniqueID = self.forumArray[_index].forumUniqueID
            self.zoneImageIV.setImage(imageStr: self.forumArray[_index].coverImageURL, placeholder: Images.fanZOne)
        }
        
        fanzoneNameTF.isSearchEnable = false
        fanzoneNameTF.optionArray = forumArray.map({$0.title})
        fanzoneNameTF.arrowSize = 10
        fanzoneNameTF.arrowColor = .white
        fanzoneNameTF.isSearchEnable = false
        fanzoneNameTF.semanticContentAttribute = .forceLeftToRight
        fanzoneNameTF.didSelect{(selectedText , _index ,id) in
            
            print("Selected String: \(selectedText) \n index: \(_index)")
            self.fanzoneNameTF.text = self.forumArray[_index].title
            self.forumUniqId = self.forumArray[_index].forumUniqueID
            self.zoneImageIV.setImage(imageStr: self.forumArray[_index].coverImageURL, placeholder: Images.fanZOne)
        }
        
        zoneImageIV.layoutIfNeeded()
    }
    
    func validate() -> Bool {
        if fanzoneNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.fanzoneEmptyAlert, view: self.view)
            return false
        } else if titleTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.titleEmptyAlert, view: self.view)
            return false
        } else if detailTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Toast.show(message: ErrorMessage.descriptionEmptyAlert, view: self.view)
            return false
        }
        return true
    }
    
    func addPostProcess() {
        var param: [String: Any] = [
            "title": titleTF.text!,
            "content_html": "<html><body> <p> \(detailTextView.text!) </p> </body> </html>",
            "is_visible": "1",
            "forum_unique_id": forumUniqId
        ]
        if imageID != 0 {
            param.updateValue([imageID], forKey: "img_ids")
        }
        activityIndicator.startAnimaton()
        ForumViewModel.shared.addEditPost(isForEdit: isForEdit, postId: postModel?.id ?? 0, parameters: param) { status, message in
            self.activityIndicator.stopAnimaton()
            if status {
                Toast.show(message: self.isForEdit ? ErrorMessage.postUpdateSuccess : ErrorMessage.postCreateSuccess, view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                Toast.show(message: message, view: self.view)
            }
        }
    }
    
    @IBAction func publishBTNTapped(_ sender: UIButton) {
        view.endEditing(true)
        if validate() {
            if let imageData = imageData {
                SettingsViewModel.shared.uploadImage(imageData: imageData, imageName: imageName) { model, status, message  in
                    self.imageID = model?.id ?? 0
                    self.addPostProcess()
                }
            } else {
                self.addPostProcess()
            }
        }
    }
    
    @IBAction func photoBTNTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            let imagePicker = ImagePicker(viewController: self)
            imagePicker .delegate = self
            imagePicker .checkCameraAuthorization()
        } else {
            let imagePicker = ImagePicker(viewController: self)
            imagePicker .delegate = self
            imagePicker .checkLibraryAuthorization()
        }
    }
}

//MARK: - ImagePicker Delegate
extension CreatePostVC: ImagePickerDelegate, UINavigationControllerDelegate {
    func pickerCanceled() {}
    
    func finishedPickingImage(image: UIImage, imageName: String) {
        postImageHeightConstraint.constant = 200
        postImageIV.image = image
        self.imageName = imageName
        imageData = image.jpegData(compressionQuality: 0.7) ?? Data()
    }
}
