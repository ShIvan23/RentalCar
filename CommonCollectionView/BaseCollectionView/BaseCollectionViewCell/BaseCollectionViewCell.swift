//
//  BaseCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import Kingfisher
import SnapKit
import UIKit

protocol BaseCollectionCell where Self: UICollectionViewCell {
    func setupCell(model: Model)
}

/// Ячейка для отображения всех машин
final class BaseCollectionViewCell: UICollectionViewCell, BaseCollectionCell {
    func setupCell(model: Model) {
        print("+++ ty ty")
    }
    
    
    private let nameCarLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let carImage: UIImageView = {
        let imageView = UIImageView()
        imageView.roundCornersWithRadius(20)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let busyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let busyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.text = "Выбрать"
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
    
    func setupCell(model: CarModel2, categoryPrice: CategoryPrice) {
        nameCarLabel.text = model.name
        let urlImage = URL(string: model.thumb ?? "")
        carImage.kf.setImage(with: urlImage)
        
        let carIsBusy = model.isBusy
        busyImageView.image = carIsBusy ? UIImage(named: "failure") : UIImage(named: "success")
        busyLabel.text = carIsBusy ? "Занята" : "Свободна"
        
        switch categoryPrice {
        case .personPrice:
            priceLabel.text = "\(model.price?.withoutNDS?.price ?? 0) ₽ / сутки"
            
            // TODO: - Поменять здесь цены на коммерческие
        case .commercialPriceWithNDS:
            priceLabel.text = "\(model.price?.withNDS?.price ?? 0) ₽ / сутки"
            
        case .commercialPriceWithoutNDS:
            priceLabel.text = "\(model.price?.withoutNDS?.price ?? 0) ₽ / сутки"
        }
        
    }
    
    private func setLayout() {
        [nameCarLabel, carImage, priceLabel, gradientView, orderLabel, busyImageView, busyLabel].forEach { contentView.addSubview($0) }
        
        gradientView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        orderLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gradientView.snp.bottom)
            make.left.equalTo(gradientView.snp.left)
            make.right.equalTo(gradientView.snp.right)
            make.height.equalTo(gradientView.snp.height)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gradientView.snp.top).inset(-4)
            make.left.right.equalToSuperview().inset(16)
        }
        
        busyLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceLabel.snp.top).inset(-4)
            make.centerX.equalTo(contentView.snp.centerX).offset(16)
        }
        
        busyImageView.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.trailing.equalTo(busyLabel.snp.leading).inset(-8)
            make.centerY.equalTo(busyLabel.snp.centerY)
        }
        
        carImage.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(120)
            make.bottom.equalTo(busyLabel.snp.top)
        }
        
        nameCarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(8)
        }
    }
}
