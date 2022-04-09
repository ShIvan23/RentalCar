//
//  ConditionTableViewCell.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import UIKit

final class ConditionTableViewCell: UITableViewCell {
    
    private let circleGreenView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexString: "#4ec378")
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with string: String) {
        descriptionLabel.text = string
    }
    
    private func layout() {
        [circleGreenView, descriptionLabel].forEach { contentView.addSubview($0) }
        
        circleGreenView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(16)
            make.centerY.equalTo(descriptionLabel.snp.centerY)
            make.height.width.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(circleGreenView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
}
