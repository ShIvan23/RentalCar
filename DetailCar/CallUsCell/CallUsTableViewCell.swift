//
//  CallUsTableViewCell.swift
//  RentalCar
//
//  Created by Ivan on 12.03.2022.
//

import SnapKit
import UIKit

protocol CallUsDelegate: AnyObject {
    func callUs()
}

class CallUsTableViewCell: UITableViewCell {
    
    weak var delegate: CallUsDelegate?

    private lazy var callUsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Позвонить нам", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(callUsButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        callUsButton.setCustomGradient()
    }
    
    private func layout() {
        contentView.addSubview(callUsButton)
        
        callUsButton.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(contentView).inset(16)
        }
    }
    
    @objc private func callUsButtonAction() {
        delegate?.callUs()
    }
}
