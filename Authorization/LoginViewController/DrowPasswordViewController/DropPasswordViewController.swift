//
//  DropPasswordViewController.swift
//  RentalCar
//
//  Created by Ivan on 31.05.2022.
//

import UIKit
import SnapKit

final class DropPasswordViewController: UIViewController, ToastViewShowable {
    
    private enum AlertEvent {
        case empty
        case notContains
    }
    
    var showingToast: ToastView?
    
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
        guard validateemailTextField() else { return }
        let dropPassword = DropPassword(email: emailTextField.text!)
        
        rentalManager.postDropPassword(email: dropPassword) { [weak self] result in
            switch result {
            case .success(let model):
                print("success")
                self?.showSuccessToast(with: "Вам на почту отправлен новый пароль")
            case .failure(let error):
                self?.showFailureToast(with: error.toString() ?? "")
            }
        }
    }
    
    private func validateemailTextField() -> Bool {
        guard !emailTextField.text!.isEmpty else {
            showAlert(error: .empty)
            return false
        }
        
        guard emailTextField.text!.contains("@"),
              emailTextField.text!.contains(".") else {
            showAlert(error: .notContains)
            return false
        }
        return true
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
    
    private func showAlert(error: AlertEvent, apiError: String = "") {
        var text = ""
        var message = "Попробуйте еще раз."
        switch error {
        case .empty:
            text = "Email пустой"
            message = "Введите Ваш email"
        case .notContains:
            text = "Кажется, Вы не верно указали email"
        }
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
