//
//  ImageView+Extra.swift
//  Comet Sports
//
//  Created by iosDev on 06/03/2024.
//

import UIKit

extension UIImageView {
    func roundCornersWithLayerMask(cornerRadii: CGFloat, corners: UIRectCorner,bound:CGRect) {
        let path = UIBezierPath(roundedRect: bound,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
    
    func setImage(imageStr: String, placeholder: UIImage? = nil) {
        self.kf.indicatorType = .activity
        if placeholder != nil {
            self.kf.setImage(with: URL(string: imageStr), placeholder: placeholder)
        } else {
            self.kf.setImage(with: URL(string: imageStr))
        }
    }
}
