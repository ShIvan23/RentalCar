//
//  TextField.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 30.03.2023.
//

import UIKit

final class TextField: UITextField {
    private let inset: CGFloat = 10
    
    init(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        super.init(frame: .zero)
        customizeTextFieldWith(placeholder: placeholder, keyboardType: keyboardType, isSecure: isSecure)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // placeholder position
     override func textRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: inset, dy: inset)
     }

     // text position
     override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: inset, dy: inset)
     }
    
    private func customizeTextFieldWith(placeholder: String, keyboardType: UIKeyboardType, isSecure: Bool) {
        backgroundColor = .systemGray6
        self.placeholder = placeholder
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        self.keyboardType = keyboardType
        isSecureTextEntry = isSecure
    }
}
