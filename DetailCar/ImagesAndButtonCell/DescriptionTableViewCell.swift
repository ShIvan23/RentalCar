//
//  DescriptionTableViewCell.swift
//  RentalCar
//
//  Created by Ivan on 09.02.2022.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    func setupCell(_ description: NSMutableAttributedString) {
        descriptionLabel.attributedText = description
        layout()
    }
    
    private func layout() {
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }

}
