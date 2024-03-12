//
//  Utility.swift
//  Comet Sports
//
//  Created by iosDev on 30/07/2023.
//

import UIKit
import ProgressHUD

class Utility: NSObject {
    
    class func dismissProgress() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    
    class func showProgress() {
        DispatchQueue.main.async {
            ProgressHUD.colorBackground = UIColor.black.withAlphaComponent(0.2)
            ProgressHUD.colorHUD = .baseColor
            ProgressHUD.colorAnimation = .baseColor
            ProgressHUD.show("Loading...".localized, interaction: false)
        }
    }
    class func showProgress(message:String) {
        DispatchQueue.main.async {
            ProgressHUD.colorBackground = UIColor.black.withAlphaComponent(0.2)
            ProgressHUD.colorHUD = .baseColor
            ProgressHUD.colorAnimation = .baseColor
            ProgressHUD.show(message, interaction: false)
        }
    }
    
    class func showProgress(progress: Float) {
        DispatchQueue.main.async {
            ProgressHUD.colorBackground = UIColor.black.withAlphaComponent(0.2)
            ProgressHUD.colorHUD = .baseColor
            ProgressHUD.colorAnimation = .baseColor
            ProgressHUD.colorProgress = .baseColor
            ProgressHUD.showProgress(CGFloat(progress), interaction: false)
        }
    }
}

class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}
