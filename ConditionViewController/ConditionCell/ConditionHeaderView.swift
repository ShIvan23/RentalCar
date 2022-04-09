//
//  ConditionHeaderView.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit

final class ConditionHeaderView: UIView {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeader(with text: String) {
        headerLabel.text = text
    }
    
    private func layout() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(10)
        }
    }
}
