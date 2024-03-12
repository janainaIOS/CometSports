

import UIKit

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

@IBDesignable
class CustomUIView: UIView {
    
    
    //Shadow
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            self.layer.shadowColor = self.shadowColor.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.layer.shadowOpacity = self.shadowOpacity
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.layer.shadowOffset = self.shadowOffset
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.layer.shadowRadius = self.shadowRadius
        }
    }
    
}

@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1.0)
        /*
         startPoint = CGPoint(x: 0.25, y: 0.5) endPoint = CGPoint(x: 0.75, y: 0.5) - left (50%)to right
         startPoint = CGPoint(x: 0.0, y: 0.0) endPoint = CGPoint(x: 1.0, y: 1.0) - top(75%) to bottom
         startPoint = CGPoint(x: 0.5, y: 0.0) endPoint = CGPoint(x: 0.5, y: 1.0) - top(60%) to bottom
         startPoint = CGPoint(x: 0.3, y: 0.0) endPoint = CGPoint(x: 0.3, y: 0.8) - top(50%) to bottom
         */
    }
}

@IBDesignable extension UITableView {
    @IBInspectable
    var isEmptyRowsHidden: Bool {
        get {
            return tableFooterView != nil
        }
        set {
            if newValue {
                tableFooterView = UIView(frame: .zero)
            } else {
                tableFooterView = nil
            }
            separatorInset = .zero
            
        }
    }
}

