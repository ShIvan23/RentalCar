//
//  RegisterViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import UIKit

protocol RegisterDelegate: AnyObject {
    func completeRegister()
}

final class RegisterViewController: UIViewController, ToastViewShowable {
    
    // TODO: - Здесь кнопка забыли пароль? И сброс пароля на почту
    
    private enum AlertEvent {
        case validateName
        case validateNumber
        case validateEmail
        case validatePassword
        case failureRegister
    }
    
    var showingToast: ToastView?
    
    weak var delegate: RegisterDelegate?
    
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите ФИО"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var nameTextField = TextField(placeholder: "Ваши ФИО")
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите номер телефона"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var numberTextField = TextField(placeholder: "Ваш номер телефона", keyboardType: .numberPad)
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите почту"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var emailTextField = TextField(placeholder: "Ваша почта")
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Придумайте пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var passwordTextField = TextField(placeholder: "Ваш пароль", isSecure: true)
    
    private let repeatPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repeatPasswordTextField = TextField(placeholder: "Повторите пароль", isSecure: true)
    
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
        label.text = "После регистрации Вам на почту придет 6-ти значный код"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let privacyLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: "Нажимая зарегистрироваться, Вы подтверждаете политику конфиденциальности и пользовательское соглашение")
        text.setColorForText("политику конфиденциальности и пользовательское соглашение", with: .blue)
        label.attributedText = text
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
        addTextFieldsDelegate()
        addGestureToHideKeyboard()
        addGestureForPrivacyLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        registerButton.setCustomGradient()
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
        guard validateAllTextFields() else { return }
        let user = UserRegister(name: nameTextField.text!,
                                phone: numberTextField.text!,
                                email: emailTextField.text!,
                                password: passwordTextField.text!)
        
        rentalManager.postRegisterUser(user: user) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    AppState.shared.saveToUserDefaults(key: AppStateKeys.wasSentRegisterCodeKey, value: true)
                    AppState.shared.userEmail = user.email
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.completeRegister()
                    AnalyticEvent.userHasRegistered.send()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(error: .failureRegister)
                }
            }
        }
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
    
    @objc private func gestureForPrivacyLabelAction() {
        let privacyViewController = PrivacyViewController()
        navigationController?.pushViewController(privacyViewController, animated: true)
    }
    
    private func validateEmail() -> Bool {
        let first = emailTextField.text!.contains("@")
        let second = emailTextField.text!.contains(".")
        return first && second
    }
    
    private func validatePassword() -> Bool {
        let first = !passwordTextField.text!.isEmpty
        let second = !repeatPasswordTextField.text!.isEmpty
        let third = passwordTextField.text! == repeatPasswordTextField.text!
        return first && second && third
    }
    
    private func validateName() -> Bool {
        return !nameTextField.text!.isEmpty
    }
    
    private func validateNumber() -> Bool {
        return !numberTextField.text!.isEmpty
    }
    
    private func validateAllTextFields() -> Bool {
        guard validateName() else {
            showAlert(error: .validateName)
            return false
        }
        guard validateNumber() else {
            showAlert(error: .validateNumber)
            return false
        }
        guard validateEmail() else {
            showAlert(error: .validateEmail)
            return false
        }
        guard validatePassword() else {
            showAlert(error: .validatePassword)
            return false
        }
        return true
    }
    
    private func showAlert(error: AlertEvent) {
        var text = ""
        var message = "Попробуйте еще раз."
        switch error {
        case .validateName:
            text = "Вы не ввели ФИО"
            message = "Заполните все поля"
        case .validateNumber:
            text = "Вы не ввели номер телефона"
            message = "Заполните все поля"
        case .validateEmail:
            text = "Вы не правильно ввели почту"
        case .validatePassword:
            text = "Ваши пароли не совпадают"
        case .failureRegister:
            text = "Произошла ошибка"
        }
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Регистрация"
    }
    
    private func addTextFieldsDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }
    
    private func addGestureToHideKeyboard() {
        view.addTapGestureToHideKeyboard()
    }
    
    private func addGestureForPrivacyLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureForPrivacyLabelAction))
        privacyLabel.addGestureRecognizer(tapGesture)
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
        
        [nameLabel, nameTextField, numberLabel, numberTextField, emailLabel, emailTextField, passwordLabel, passwordTextField, repeatPasswordLabel, repeatPasswordTextField, codeLabel, registerButton, privacyLabel].forEach { contentView.addSubview($0) }
      
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameTextField.snp.bottom).offset(16)
        }

        numberTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(numberLabel.snp.bottom).offset(8)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(numberTextField.snp.bottom).offset(16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
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
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(repeatPasswordTextField.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }

}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
