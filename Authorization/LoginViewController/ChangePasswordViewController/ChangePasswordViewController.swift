//
//  ChangePasswordViewController.swift
//  RentalCar
//
//  Created by Ivan on 31.05.2022.
//

import UIKit

final class ChangePasswordViewController: UIViewController, ToastViewShowable {
    
    private enum AlertEvent {
        case validateOldAndNew
        case validateNewAndRepeat
    }
    
    var showingToast: ToastView?
    
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let oldPassLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите Ваш старый пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var oldPassTextField = TextField(placeholder: "Cтарый пароль")
    
    private let newPassLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите Ваш новый пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var newPassTextField = TextField(placeholder: "Новый пароль")
    
    private let repeatNewPassLabel: UILabel = {
        let label = UILabel()
        label.text = "Повторите Ваш новый пароль"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repeatNewPassTextField = TextField(placeholder: "Повторите новый пароль")
    
    private lazy var changeButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Сменить пароль", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(changeButtonAction), for: .touchUpInside)
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
        changeButton.setCustomGradient()
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
    
    @objc private func changeButtonAction() {
        print("change")
    }
    
    private func validateNewAndRepeatPass() -> Bool {
        let valid = newPassTextField.text! == repeatNewPassTextField.text!
        return valid
    }
    
    private func validateOldAndNewPass() -> Bool {
        let valid = oldPassTextField.text! != newPassTextField.text!
        return valid
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
    
    private func showAlert(error: AlertEvent) {
        var text = ""
        var message = "Попробуйте еще раз."
        switch error {
        case .validateOldAndNew:
            text = "Ваш старый и новый пароль совпадают"
            message = "Придумайте другой пароль"
        case .validateNewAndRepeat:
            text = "Вы неверно повторили пароль"
        }
        let alert = UIAlertController(title: text, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Понятно", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Смена пароля"
    }
    
    private func addTextFieldsDelegate() {
        oldPassTextField.delegate = self
        newPassTextField.delegate = self
        repeatNewPassTextField.delegate = self
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
        
        [oldPassLabel, oldPassTextField, newPassLabel, newPassTextField, repeatNewPassLabel, repeatNewPassTextField, changeButton].forEach { contentView.addSubview($0) }
        
        oldPassLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(16)
        }
        
        oldPassTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(oldPassLabel.snp.bottom).offset(8)
        }
        
        newPassLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(oldPassTextField.snp.bottom).offset(16)
        }
        
        newPassTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(newPassLabel.snp.bottom).offset(8)
        }
        
        repeatNewPassLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(newPassTextField.snp.bottom).offset(16)
        }
        
        repeatNewPassTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(repeatNewPassLabel.snp.bottom).offset(8)
        }
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(repeatNewPassTextField.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPassTextField {
            newPassTextField.becomeFirstResponder()
        } else if textField == newPassTextField {
            repeatNewPassTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
