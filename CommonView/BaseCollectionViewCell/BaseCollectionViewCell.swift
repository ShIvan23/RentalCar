//
//  BaseCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

final class BaseCollectionViewCell: UICollectionViewCell {
    
    private let nameCarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "KIA Rio"
        label.textAlignment = .center
        return label
    }()
    
    private let carImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCornersWithRadius(20)
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.text = "2450 ₽ / сутки"
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .systemGray6
        contentView.roundCornersWithRadius(20)
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        contentView.layer.borderWidth = 1
    }
    
    private func setLayout() {
        [nameCarLabel, carImage, priceLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameCarLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameCarLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameCarLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            carImage.topAnchor.constraint(equalTo: nameCarLabel.bottomAnchor, constant: 16),
            carImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            carImage.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -16),
            carImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
