//
//  UICollectionViewCell+Extension.swift
//  RentalCar
//
//  Created by Ivan on 29.01.2022.
//

import UIKit

extension UICollectionViewCell {
    func customizeCell() {
        contentView.backgroundColor = .systemGray6
        contentView.roundCornersWithRadius(20)
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        contentView.layer.borderWidth = 1
    }
}
