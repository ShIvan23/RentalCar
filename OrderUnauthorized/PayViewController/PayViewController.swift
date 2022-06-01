//
//  PayViewController.swift
//  RentalCar
//
//  Created by Ivan on 01.06.2022.
//

import UIKit
import SnapKit

class PayViewController: UIViewController {
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "inProgress")
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Оплата находится в разработке и будет доступна в следущей версии приложения"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Назад", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backButton.setCustomGradient()
    }
    
    @objc private func backButtonAction() {
        navigationController?.popViewController(animated: true)
    }

    private func layout() {
        [infoImageView, infoLabel, backButton].forEach { view.addSubview($0) }
        
        infoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.left.right.equalToSuperview().inset(16)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.bottom.equalTo(infoLabel.snp.top).inset(-40)
            make.height.width.equalTo(200)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        backButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp_bottomMargin).inset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Оплата"
    }
}
