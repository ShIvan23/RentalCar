//
//  BaseCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

/// Ячейка для отображения всех машин
final class BaseCollectionViewCell: UICollectionViewCell {
    
    private let nameCarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let carImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.roundCornersWithRadius(20)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Заказать"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        customizeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientView.setCustomGradient()
    }
    
    func setupCell(model: CarModel, categoryPrice: CategoryPrice) {
        nameCarLabel.text = model.marka + model.model
        carImage.image = model.previewImage
        
        switch categoryPrice {
        case .personPrice:
            priceLabel.text = "\(model.personPrice) ₽ / сутки"
            
        case .commercialPriceWithNDS:
            priceLabel.text = "\(model.commercialPriceWithNDS) ₽ / сутки"
            
        case .commercialPriceWithoutNDS:
            priceLabel.text = "\(model.commercialPriceWithoutNDS) ₽ / сутки"
        }
        
    }
    
    private func setLayout() {
        [nameCarLabel, carImage, priceLabel, gradientView, orderLabel].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            nameCarLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameCarLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameCarLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            carImage.topAnchor.constraint(equalTo: nameCarLabel.bottomAnchor, constant: 8),
            carImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            carImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            carImage.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: carImage.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gradientView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            orderLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            orderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            orderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            orderLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
