//
//  ProfileLogoutTableViewCell.swift
//  RentalCar
//
//  Created by Ivan on 24.05.2022.
//

import UIKit
import SnapKit

final class ProfileLogoutTableViewCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .red
        return label
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
        [nameLabel].forEach { contentView.addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func customizeView() {
        contentView.backgroundColor = .white
    }
}
