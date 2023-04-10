//
//  EmptyStockCollectionViewCell.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 05.04.2023.
//

import SnapKit

final class EmptyStockCollectionViewCell: UICollectionViewCell {
    
    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "emptyPhoto")
        return imageView
    }()
    
    private let emptyStockLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.text = "В этом разделе пока что нет акций"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [emptyImageView, emptyStockLabel].forEach { contentView.addSubview($0) }
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.topMargin.equalToSuperview().offset(100)
            make.width.height.equalTo(100)
        }
        
        emptyStockLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
    }
}
