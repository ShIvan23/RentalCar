//
//  StockCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 20.02.2022.
//

import Kingfisher
import SnapKit
import UIKit

/// Ячейка для акций
final class StockCollectionViewCell: UICollectionViewCell {
    
    private let stockImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let nameStockLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        customizeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        gradientView.applyGradient(colors: [UIColor(hexString:"#000000" , alpha: 0.15), UIColor(hexString: "#065656")], cornerRadius: 20, position: .topToBottom)
        
    }
    
    func setupCell(promoModel: Promo) {
        nameStockLabel.text = promoModel.title
        let urlImage = URL(string: promoModel.thumb)
        stockImageView.kf.setImage(with: urlImage)
    }
    
    private func layout() {
        [stockImageView, gradientView, nameStockLabel].forEach { contentView.addSubview($0) }
        
        
        stockImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        nameStockLabel.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(16)
        }
        
        gradientView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(stockImageView)
        }
    }
}
