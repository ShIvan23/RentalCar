//
//  UIViewController+Extension.swift
//  RentalCar
//
//  Created by Ivan on 05.02.2022.
//

import UIKit

extension UIViewController {
    static func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
