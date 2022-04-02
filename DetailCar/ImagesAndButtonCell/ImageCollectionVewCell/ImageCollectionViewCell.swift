//
//  ImageCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 05.02.2022.
//

import Kingfisher
import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    func setupCellWith(image: String) {
        layout()
        let urlImage = URL(string: image)
        carImageView.kf.setImage(with: urlImage)
    }
    
    private func layout() {
        contentView.addSubview(carImageView)
//        contentView.backgroundColor = .yellow
        
        NSLayoutConstraint.activate([
            carImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            carImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
