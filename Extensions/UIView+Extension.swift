//
//  UIView+Extension.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

extension UIView {
    
    /// Method adds shadow and corner radius for top of view by default.
    ///
    /// - Parameters:
    ///   - top: Top corners
    ///   - bottom: Bottom corners
    ///   - radius: Corner radius
    func roundCornersWithRadius(_ radius: CGFloat, top: Bool? = true, bottom: Bool? = true, shadowEnabled: Bool = true) {
        var maskedCorners = CACornerMask()
        
        if shadowEnabled {
            clipsToBounds = true
            layer.masksToBounds = false
            layer.shadowOpacity = 0.5
            layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 4, height: 4)
        }
        
        switch (top, bottom) {
        case (true, false):
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case (false, true):
            maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case (true, true):
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        default:
            break
        }
        
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
}

enum GradientPosition {
    case topToBottom
    case leftToRight
    case topLeftToBottomRight
    case topRightToBottomLeft
}

extension UIView {
    func setCustomGradient() {
        applyGradient(colors: [UIColor(hexString: "#4ec378", alpha: 1.0), UIColor(hexString: "#0c8269", alpha: 1.0)], cornerRadius: 10)
    }
    
    func applyGradient(colors: [UIColor],
                       cornerRadius: CGFloat? = nil,
                       position: GradientPosition = .topToBottom) {
        
        if let _ = layer.sublayers?.first as? CAGradientLayer {
            layer.sublayers?.first?.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer.createGradient(colors: colors,
                                                           cornerRadius: cornerRadius == nil ? self.layer.cornerRadius : cornerRadius,
                                                           position: position)
        
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension CAGradientLayer {
    static func createGradient(colors: [UIColor],
                               cornerRadius: CGFloat? = nil,
                               position: GradientPosition = .topToBottom) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        
        switch position {
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .topRightToBottomLeft:
            gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        
        gradientLayer.cornerRadius = cornerRadius ?? 0
        return gradientLayer
    }
    
}

extension UIView {
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}
