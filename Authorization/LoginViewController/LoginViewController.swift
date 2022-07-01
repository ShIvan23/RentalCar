//
//  LoginViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func userDidLogin()
}

final class LoginViewController: UIViewController, ToastViewShowable {
    
    private enum AlertEvent {
        case validateEmail
        case validatePassword
        case successRegister
        case failureLogin
    }
    
    var showingToast: ToastView?
    private var wasSentRegisterCodeKey: Bool!
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    var willAppearAfterEnterCode = false
    weak var delegate: LoginViewControllerDelegate?
    
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
        label.text = "Введите почту"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var loginTextField = TextField(placeholder: "Ваша почта")
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var passwordTextField = TextField(placeholder: "Ваш пароль", isSecure: true)
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Войти", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return button
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
    
    private lazy var enterCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Для завершения регистрации введите код из письма"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var enterCodeButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Ввести код", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(enterCodeButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        wasSentRegisterCodeKey = AppState.shared.wasSentRegisterCode
        layout()
        customize()
        addTextFieldsDelegate()
        addGestureToHideKeyboard()
        addGestureForPrivacyLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard !willAppearAfterEnterCode else {
            updateLayoutAfterEnterCode()
            return
        }
        
        wasSentRegisterCodeKey = AppState.shared.wasSentRegisterCode
        updateLayoutIfNeeded()
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
        if wasSentRegisterCodeKey {
            enterCodeButton.setCustomGradient()
        }
    }
    
    @objc private func registerButtonAction() {
        let registerVC = RegisterViewController()
        registerVC.delegate = self
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc private func loginButtonAction() {
        guard allLoginValidates() else { return }
        lockView()
        let user = Login(email: loginTextField.text!,
                         password: passwordTextField.text!)
        
        rentalManager.login(user: user) { [weak self] result in
            switch result {
            case.success(let model):
                AppState.shared.saveTokens(model: model)
                AppState.shared.saveToUserDefaults(key: AppStateKeys.userWasLogin, value: true)
                self?.getUserProfile()
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                    self?.unlock()
                    self?.delegate?.userDidLogin()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.unlock()
                    self?.showAlert(event: .failureLogin, message: error.toString() ?? "")
                }
            }
        }
    }
    
    @objc private func enterCodeButtonAction() {
        let enterCodeVC = EnterCodeViewController()
        enterCodeVC.delegate = self
        navigationController?.pushViewController(enterCodeVC, animated: true)
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
    
    private func showAlert(event: AlertEvent, message: String = "") {
        var text = ""
        var message = "Попробуйте еще раз."
        switch event {
        case .validatePassword:
            text = "Пароль пустой"
        case .validateEmail:
            text = "Вы не правильно ввели почту"
        case .successRegister:
            text = "Регистрация завершена"
            message = "Войдите в профиль с Вашей почтой и паролем"
        case .failureLogin:
            text = "Ошибка"
            message = message != "" ? message : "Проверьте почту и пароль"
        }
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func getUserProfile() {
        rentalManager.getUserProfile { result in
            switch result {
            case .success(let model):
                AppState.shared.saveToUserDefaults(key: .userWasConfirmed, value: model.isDocumentConfirm)
            case .failure(let error):
                debugPrint("error.toString() = \(error.toString())")
            }
        }
    }
    
    private func addGestureForPrivacyLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureForPrivacyLabelAction))
        privacyLabel.addGestureRecognizer(tapGesture)
    }
    
    private func allLoginValidates() -> Bool {
        guard validateEmail() else {
            showAlert(event: .validateEmail)
            return false
        }
        guard validatePassword() else {
            showAlert(event: .validatePassword)
            return false
        }
        return true
    }
    
    private func validatePassword() -> Bool {
        return !passwordTextField.text!.isEmpty
    }
    
    private func validateEmail() -> Bool {
        let first = loginTextField.text!.contains("@")
        let second = loginTextField.text!.contains(".")
        return first && second
    }
    
    private func customize() {
        title = "Войти"
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
        
        [logoImageView, loginLabel, loginTextField, passwordLabel, passwordTextField, loginButton, privacyLabel, registerLabel, registerButton].forEach { contentView.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(120)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(20)
            make.top.equalTo(logoImageView.snp.bottom)
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
        
        privacyLabel.snp.makeConstraints { make in
            make.top.equalTo( loginButton.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
        }

        wasSentRegisterCodeKey ? layoutForNextRegister() : layoutForFirstRegister()
    }
    
    /// Если пользователь еще не отправлял на почту код подтверждения, то кнопка ввести код не нужна
    private func layoutForFirstRegister() {
        [registerLabel, registerButton].forEach { contentView.addSubview($0) }
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(registerLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    /// Если пользователь уже отправлял на почту код подтверждения, то кнопка ввести код нужна
    private func layoutForNextRegister() {
        [enterCodeLabel, enterCodeButton, registerLabel, registerButton].forEach { contentView.addSubview($0) }
        
        registerLabel.text = "Для регистрации с новой почты, нажмите 'Зарегистрироваться'"
        
        enterCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        enterCodeButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(enterCodeLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(enterCodeButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(registerLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    /// После того как пользователь отправил на почту код подтверждения, надо показать кнопку с с вводом кода
    private func updateLayoutIfNeeded() {
        if wasSentRegisterCodeKey {
            [enterCodeLabel, enterCodeButton].forEach{ contentView.addSubview($0) }
            
            registerLabel.text = "Для регистрации с новой почты, нажмите 'Зарегистрироваться'"
            registerLabel.snp.removeConstraints()
            registerButton.snp.removeConstraints()
            
            enterCodeLabel.snp.makeConstraints { make in
                make.top.equalTo(privacyLabel.snp.bottom).offset(30)
                make.left.right.equalToSuperview().inset(16)
            }

            enterCodeButton.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.equalTo(enterCodeLabel.snp.bottom).offset(8)
                make.height.equalTo(40)
            }
            
            registerLabel.snp.makeConstraints { make in
                make.top.equalTo(enterCodeButton.snp.bottom).offset(30)
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
    
    /// После отправки кода на бэк, кнопка с отправкой кода больше не нужна
    private func updateLayoutAfterEnterCode() {
        enterCodeLabel.snp.removeConstraints()
        enterCodeButton.snp.removeConstraints()
        registerLabel.snp.removeConstraints()
        registerButton.snp.removeConstraints()
        
        enterCodeLabel.removeFromSuperview()
        enterCodeButton.removeFromSuperview()
        
        registerLabel.text = "Если у Вас ещё нет профиля, то зарегистрируйтесь"
        
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        registerButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(registerLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        willAppearAfterEnterCode = false
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

// MARK: - RegisterDelegate

extension LoginViewController: RegisterDelegate {
    func completeRegister() {
        showSuccessToast(with: "Вам на почту оправлено письмо с кодом")
    }
}


// MARK: - EnterCodeDelegate

extension LoginViewController: EnterCodeDelegate {
    func changeLayout() {
        willAppearAfterEnterCode = true
    }
    
    func didFinishRegistration() {
        showAlert(event: .successRegister)
    }
}
