//
//  ProfileSelectTableViewCell.swift
//  RentalCar
//
//  Created by Ivan on 24.05.2022.
//

import UIKit
import SnapKit

final class ProfileSelectTableViewCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        customizeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with text: String) {
        nameLabel.text = text
    }
    
    private func layout() {
        [nameLabel, arrowImageView].forEach { contentView.addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(contentView.snp.left).offset(16)
            make.bottom.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(16)
            make.height.width.equalTo(30)
            make.left.equalTo(nameLabel.snp.right).offset(16)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    private func customizeView() {
        contentView.backgroundColor = .white
    }

}
