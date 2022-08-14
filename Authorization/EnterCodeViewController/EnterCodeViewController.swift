//
//  EnterCodeViewController.swift
//  RentalCar
//
//  Created by Ivan on 16.04.2022.
//

import UIKit

protocol EnterCodeDelegate: AnyObject {
    func changeLayout()
    func didFinishRegistration()
}

final class EnterCodeViewController: UIViewController, ToastViewShowable {
    
    private enum AlertEvent {
        case validateCode
        case validateEmail
        case sendingError
        case againSendingError
    }
    
    var showingToast: ToastView?
    weak var delegate: EnterCodeDelegate?
    
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    private var codeNumber: Int = 0
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите 6-ти значный код из письма"
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var codeTextField = TextField(placeholder: "Введите код из письма", keyboardType: .numberPad)
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Проверьте почту перед отправкой"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var emailTextField = TextField(placeholder: "Ваша почта")
    
    private lazy var sendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Завершить регистрацию", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendCodeButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let getCodeAgainLabel: UILabel = {
        let label = UILabel()
        label.text = "Если Вам не пришел код на почту, отправьте повторно"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var sendCodeAgainButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Отправить код повторно", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendCodeAgainButtonAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        customizeView()
        setupEmail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendCodeButton.setCustomGradient()
        sendCodeAgainButton.setCustomGradient()
    }
    
    @objc private func sendCodeButtonAction() {
        guard validateAllTextFields() else { return }
        let userConfirm = UserConfirm(email: emailTextField.text!,
                                      code: codeNumber)
        rentalManager.postConfirmUser(user: userConfirm) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    AppState.shared.saveToUserDefaults(key: .wasFinishedRegistration, value: true)
                    self?.delegate?.changeLayout()
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.didFinishRegistration()
                    AnalyticEvent.userHasConfirnedCode.send()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(event: .sendingError)
                }
            }
        }
    }
    
    @objc private func sendCodeAgainButtonAction() {
        guard !emailTextField.text!.isEmpty else {
            showAlert(event: .validateEmail)
            return
        }
        let againConfirmCode = AgainConfirmCode(email: emailTextField.text!)
        rentalManager.postAgainConfirmCode(user: againConfirmCode) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.showSuccessToast(with: "Вам на почту отправлен новый код")
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(event: .againSendingError)
                }
            }
        }
    }
    
    private func validateAllTextFields() -> Bool {
        guard validateCode() else {
            showAlert(event: .validateCode)
            return false
        }
        guard validateEmail() else {
            showAlert(event: .validateEmail)
            return false
        }
        return true
    }
    
    private func validateCode() -> Bool {
        let first = codeTextField.text!.count == 6
        let second = validateOnlyNumbers()
        return first && second
    }
    
    private func validateEmail() -> Bool {
        let first = emailTextField.text!.contains("@")
        let second = emailTextField.text!.contains(".")
        return first && second
    }
    
    private func validateOnlyNumbers() -> Bool {
        guard let codeNumber =  Int(codeTextField.text!) else { return false }
        self.codeNumber = codeNumber
        return true
    }
    
    private func showAlert(event: AlertEvent) {
        var text = ""
        let message = "Попробуйте еще раз."
        switch event {
        case .validateCode:
            text = "Код должен быть из 6-ти символов"
        case .validateEmail:
            text = "Вы не правильно ввели почту"
        case .sendingError:
            text = "Неверный код или почта"
        case .againSendingError:
            text = "Проверьте, что Вы верно ввели почту"
        }
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func customizeView() {
        title = "Подтверждение почты"
        view.backgroundColor = .white
    }
    
    private func setupEmail() {
        emailTextField.text = AppState.shared.userEmail
    }
    
    private func layout() {
        [codeLabel, codeTextField, emailLabel, emailTextField, sendCodeButton, getCodeAgainLabel, sendCodeAgainButton].forEach { view.addSubview($0) }
        
        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        codeTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(codeLabel.snp.bottom).offset(8)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(codeTextField.snp.bottom).offset(16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
        }
        
        sendCodeButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        getCodeAgainLabel.snp.makeConstraints { make in
            make.top.equalTo(sendCodeButton.snp.bottom).offset(60)
            make.left.right.equalToSuperview().inset(16)
        }
        
        sendCodeAgainButton.snp.makeConstraints { make in
            make.top.equalTo(getCodeAgainLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}
