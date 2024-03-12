//
//  ViewController+Extra.swift
//  Comet Sports
//
//  Created by iosDev on 19/02/2024.
//

import UIKit

extension UIViewController {
    @IBAction func backClicked(_ sender: Any) {
        if self.isBeingPresented || self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert1(title: String = "  ", message: String, okBTNTitle: String = "OK".localized, okAction:@escaping () -> Void) {
        let alert = UIAlertController(title: title.localized, message: message.localized as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okBTNTitle, style: UIAlertAction.Style.default) { UIAlertAction in
            okAction()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert2(title: String = "  ", message: String, okBTNTitle: String = "OK".localized, okAction:@escaping () -> Void) {
        let alert = UIAlertController(title: title.localized, message: message.localized as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okBTNTitle, style: UIAlertAction.Style.default) { UIAlertAction in
            okAction()
        })
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
    func appPermissionAlert(type: String) {
        showAlert2(message: "\("Please enable your ".localized)\(type.localized)\(" in Settings to continue".localized)", okBTNTitle: "Settings") {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
    }
    
    // MARK: - Navigation
    public func presentViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        configure?(vc)
        present(vc, animated: true)
    }
    
    public func presentOverViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        vc.modalPresentationStyle = .overFullScreen
        configure?(vc)
        present(vc, animated: true)
    }
    
    public func navigateToViewController<T: UIViewController>(_ viewController: T.Type, storyboard: UIStoryboard, configure: ((T) -> Void)? = nil) {
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: viewController)) as! T
        configure?(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func navigateToXIBViewController<T: UIViewController>(_ viewController: T.Type, configure: ((T) -> Void)? = nil) {
        
        let vc = viewController.init(nibName: String(describing: viewController), bundle: nil)
        configure?(vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

func setfeedImageCVLayout(collectionview: UICollectionView, imageCount: Int) {
    var imagesCount = imageCount
    if imageCount > 5 {
        imagesCount = 5
    }
    if let layout = collectionview.collectionViewLayout as? FeedImageCVLayout {
        switch imagesCount {
        case 1:
            layout.layoutType = 1
            break
        case 2:
            layout.layoutType = 2
            break
        case 3:
            layout.layoutType = 3
            break
        case 4:
            layout.layoutType = 4
            break
        case 5:
            layout.layoutType = 5
            break
        default:
            layout.layoutType = 5
            break
        }
    }
}

func logoutAndRootToLoginVC() {
    //Clear UserDefaults values
    UserDefaults.standard.clearSpecifiedItems()
    
    // rootToLoginVC
    let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    guard let unwrappedWindow = window else {
        return
    }
    
    let loginVC = Storyboards.login.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    let navController = UINavigationController(rootViewController: loginVC)
    navController.isNavigationBarHidden = true
    navController.modalPresentationStyle = .fullScreen
    unwrappedWindow.rootViewController = navController
    let options: UIView.AnimationOptions = .transitionCrossDissolve
    UIView.transition(with: unwrappedWindow, duration: 1.0, options: options, animations: nil, completion: nil)
}
