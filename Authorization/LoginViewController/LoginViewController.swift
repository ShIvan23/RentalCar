//
//  LoginViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit

class LoginViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Войти", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Если у Вас ещё нет профиля, то зарегистрируйтесь"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
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
        addTextFieldsDelegate()
        addGestureToHideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loginButton.setCustomGradient()
        registerButton.setCustomGradient()
    }
    
    @objc private func registerButtonAction() {
        print("Показать экран с регистрацией")
    }
    
    @objc private func loginButtonAction() {
        print("send to backend")
    }
    
    @objc func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    private func customize() {
        view.backgroundColor = .white
    }
    
    private func addTextFieldsDelegate() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    private func addGestureToHideKeyboard() {
        view.addTapGestureToHideKeyboard()
    }
    
    private func layout() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.bottom.left.right.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.width.equalTo(scrollView)
        }
        
        [logoImageView, loginLabel, loginTextField, passwordLabel, passwordTextField, loginButton, registerLabel, registerButton].forEach { contentView.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(180)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(loginLabel.snp.bottom).offset(8)
        }

        passwordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
            make.top.equalTo(loginTextField.snp.bottom).offset(16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
        }

        loginButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(100)
            make.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(registerLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
