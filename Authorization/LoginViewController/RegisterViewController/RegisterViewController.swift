//
//  RegisterViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private enum ValidationError {
        case email
        case password
        case code
    }
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите почту"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var loginTextField = TextField(placeholder: "Ваша почта")
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Придумайте пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var passwordTextField = TextField(placeholder: "Ваш пароль")
    
    private let repeatPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repeatPasswordTextField = TextField(placeholder: "Повторите пароль")
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Зарегистрироваться", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "После регистрации Вам на почту придет 6-ти значный код. Его нужно будет ввести в этом поле"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var codeTextField = TextField(placeholder: "Введите код из письма")
    
    private lazy var sendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Отправить код", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendCodeButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
        addTextFieldsDelegate()
        addGestureToHideKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerButton.setCustomGradient()
        sendCodeButton.setCustomGradient()
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
    
    @objc private func registerButtonAction() {
        guard validateEmail() else {
            showAlert(error: .email)
            return
        }
        guard validatePassword() else {
            showAlert(error: .password)
            return
        }
        print("Отправить на бэк")
        print("Почта = \(loginTextField.text!)")
        print("Пароль = \(passwordTextField.text!)")
    }
    
    @objc private func sendCodeButtonAction() {
        guard validateCode() else {
            showAlert(error: .code)
            return
        }
        print("Отправить на бэк код = \(codeTextField.text!) ")
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
    
    private func validateEmail() -> Bool {
        let first = loginTextField.text!.contains("@")
        let second = loginTextField.text!.contains(".")
        return first && second
    }
    
    private func validatePassword() -> Bool {
        let first = !passwordTextField.text!.isEmpty
        let second = !repeatPasswordTextField.text!.isEmpty
        let third = passwordTextField.text! == repeatPasswordTextField.text!
        return first && second && third
    }
    
    private func validateCode() -> Bool {
        return codeTextField.text!.count == 6
    }
    
    private func showAlert(error: ValidationError) {
        var text = ""
        switch error {
        case .email:
            text = "Вы не правильно ввели почту"
        case .password:
            text = "Ваши пароли не совпадают"
        case .code:
            text = "Код должен быть из 6-ти символов"
        }
        let alert = UIAlertController(title: text, message: "Попробуйте еще раз.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func customize() {
        view.backgroundColor = .white
    }
    
    private func addTextFieldsDelegate() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        codeTextField.delegate = self
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
        
        [loginLabel, loginTextField, passwordLabel, passwordTextField, repeatPasswordLabel, repeatPasswordTextField, registerButton, codeLabel, codeTextField, sendCodeButton].forEach { contentView.addSubview($0) }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(loginLabel.snp.bottom).offset(8)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(loginTextField.snp.bottom).offset(16)
        }

        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
        }
        
        repeatPasswordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }

        repeatPasswordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(repeatPasswordLabel.snp.bottom).offset(8)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(16)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(codeLabel.snp.bottom).offset(8)
        }
        
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(codeTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(20)
        }
    }

}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
