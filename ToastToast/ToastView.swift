//
//  ToastView.swift
//  RentalCar
//
//  Created by Ivan on 04.04.2022.
//

import SnapKit
import UIKit

final class ToastView: UIView {
    
    enum ToastType {
        case success
        case failure
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    init(text: String,
         type: ToastType
    ) {
        super.init(frame: .zero)
        customizeView(text: text, type: type)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutToaster(in view: UIView) {
        self.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(36)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).inset(-100)
        }
    }
    
    func animateShowingToaster() {
        UIView.animate(withDuration: 0.5) {
            self.transform = CGAffineTransform(translationX: 0, y: 220)
        }
    }
    
    func animateDismissToaster(in view: UIView) {
        UIView.animate(withDuration: 0.5) {
            view.layoutIfNeeded()
            self.transform = .identity
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    private func customizeView(text: String, type: ToastType) {
        backgroundColor = .black
        layer.cornerRadius = 12
        textLabel.text = text
        
        switch type {
        case .success:
            iconImageView.image = UIImage(named: "success")
        case .failure:
            iconImageView.image = UIImage(named: "failure")
        }
    }
    
    private func layout() {
        [iconImageView, textLabel].forEach { addSubview($0) }

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(textLabel.snp.centerY)
            make.left.equalToSuperview().inset(12)
            make.width.height.equalTo(20)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(9)
            make.left.equalTo(iconImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(9)
        }
    }
}
