//
//  DropPasswordViewController.swift
//  RentalCar
//
//  Created by Ivan on 31.05.2022.
//

import UIKit
import SnapKit

final class DropPasswordViewController: UIViewController {
    
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    private let dropLabel: UILabel = {
        let label = UILabel()
        label.text = "Чтобы сбросить пароль, нужно ввести почту, с который Вы зарегистрировались. После сброса Вам на почту придет письмо с новым паролем. Позже Вы сможете сменить этот пароль."
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailTextField = TextField(placeholder: "Введите email")
    
    private lazy var dropButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Сбросить пароль", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(dropButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        addTextFieldsDelegate()
        addGestureToHideKeyboard()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropButton.setCustomGradient()
    }
    
    @objc private func dropButtonAction() {
        print("drop")
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Сбросить пароль"
    }
    
    private func addTextFieldsDelegate() {
        emailTextField.delegate = self
    }
    
    private func addGestureToHideKeyboard() {
        view.addTapGestureToHideKeyboard()
    }
    
    private func layout() {
        [dropLabel, emailTextField, dropButton].forEach { view.addSubview($0) }
        
        dropLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(dropLabel.snp.bottom).offset(8)
        }
        
        dropButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}

// MARK: - UITextFieldDelegate

extension DropPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            dropButtonAction()
            textField.resignFirstResponder()
        }
        return true
    }
}
