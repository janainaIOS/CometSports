//
//  UIView+Extra.swift
//  Comet Sports
//
//  Created by iosDev on 19/02/2024.
//

import UIKit

extension UIView {
    
    func setOnClickListener(action :@escaping () -> Void){
          let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
          tapRecogniser.onClick = action
          self.addGestureRecognizer(tapRecogniser)
      }
      
      @objc func onViewClicked(sender: ClickListener) {
          if let onClick = sender.onClick {
              onClick()
          }
      }
    
    func roundCornersWithBorderLayer(cornerRadii: CGFloat, corners: UIRectCorner, bound:CGRect, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        let maskPath = UIBezierPath(roundedRect: bound, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
        
    }
    
    func applyShadow(radius: CGFloat,
                     opacity: Float,
                     offset: CGSize,
                     color: UIColor = .lightGray) {
        layer.masksToBounds = false
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
}
