//
//  DeleteAccountViewController.swift
//  RentalCar
//
//  Created by Ivan on 31.05.2022.
//

import UIKit
import SnapKit

final class DeleteAccountViewController: UIViewController, ToastViewShowable {
    
    var showingToast: ToastView?
    
    private lazy var rentalManager: RentalManager = RentalManagerImp()
    
    private let dropLabel: UILabel = {
        let label = UILabel()
        label.text = "Нажимая кнопку «удалить», Вы удаляете все Ваши данные. Чтобы снова производить оплату из приложения, Вам нужно будет повторно зарегистрироваться."
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Удалить аккаунт", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deleteButton.setCustomGradient()
    }
    
    @objc private func deleteButtonAction() {
        print("Удалить аккаунт")
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Удалить аккаунт"
    }
    
    private func layout() {
        [dropLabel, deleteButton].forEach { view.addSubview($0) }
        
        dropLabel.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.left.right.equalToSuperview().inset(16)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp_bottomMargin).inset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}
