//
//  LegalCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 29.01.2022.
//

import UIKit

/// Ячейка для отображения категорий юр лица и категорий машин
final class LegalCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let legalImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chooseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выбрать"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        customizeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientView.setCustomGradient()
    }
    
    func setupCell(model: CarClass) {
        titleLabel.text = model.className
        legalImage.image = model.imageGroup
    }
    
    private func setupLayout() {
        [titleLabel, legalImage, gradientView, chooseLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            legalImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            legalImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            legalImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            legalImage.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: legalImage.bottomAnchor, constant: 16),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            gradientView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            chooseLabel.topAnchor.constraint(equalTo: legalImage.bottomAnchor, constant: 16),
            chooseLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            chooseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chooseLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
