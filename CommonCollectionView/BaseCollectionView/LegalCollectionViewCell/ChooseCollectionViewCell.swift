//
//  LegalCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 29.01.2022.
//

import Kingfisher

/// Ячейка для отображения категорий юр лица и категорий машин
final class ChooseCollectionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
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
    
    func setupCell(model: Model) {
        switch model {
        case let carModel as CarClass2:
            titleLabel.text = carModel.name
            let urlImage = URL(string: carModel.image ?? "")
            legalImage.kf.setImage(with: urlImage)
        case let cityModel as City:
            titleLabel.text = cityModel.name
            let urlImage = URL(string: cityModel.image)
            legalImage.kf.setImage(with: urlImage)
        case let legalModel as CommercialModel:
            titleLabel.text = legalModel.name
            legalImage.image = legalModel.image
        case let promoModel as PromoData:
            titleLabel.text = promoModel.name
            let urlImage = URL(string: promoModel.thumb)
            legalImage.kf.setImage(with: urlImage)
        case let conditionsModel as ConditionsModel:
            titleLabel.text = conditionsModel.title
            legalImage.image = conditionsModel.image
        default:
            assertionFailure("Новый тип модели")
            break
        }
    }
    
    private func setupLayout() {
        [titleLabel, legalImage, gradientView, chooseLabel].forEach {
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
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
