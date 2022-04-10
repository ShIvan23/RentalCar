//
//  LoginViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit

class LoginViewController: UIViewController {
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите логин"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var loginTextField = TextField(placeholder: "Ваш логин")
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var passwordTextField = TextField(placeholder: "Ваш пароль")
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Зарегистрироваться", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerButton.setCustomGradient()
    }
    
    @objc private func registerButtonAction() {
        print("Показать экран с регистрацией")
    }
    
    private func customize() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        
        [loginLabel, loginTextField, passwordLabel, passwordTextField, registerButton].forEach { view.addSubview($0) }
        
        passwordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        loginTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalTo(passwordLabel.snp.top).inset(-16)
        }

        loginLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
            make.bottom.equalTo(loginTextField.snp.top).inset(-8)
        }

        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
        }

        registerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
    }

}
