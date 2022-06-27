//
//  ProfileViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController, ToastViewShowable {
    
    var showingToast: ToastView?
    
    // TODO: - Здесь кнопка для смены пароля
    // TODO: - Обновление token по refreshToken
    
    private lazy var rentalManager = RentalManagerImp()
    private let profileModel = ["Отправить документы", "Сменить пароль", "Сбросить пароль", "Удалить аккаунт", "Выйти"]
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(cell: ProfileSelectTableViewCell.self)
        tableView.register(cell: ProfileLogoutTableViewCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Профиль"
    }
    
    private func logout() {
        rentalManager.logout(completion: { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                    AppState.shared.saveToUserDefaults(key: .userWasLogin, value: false)
                    AppState.shared.removeTokens()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showErrorAlert()
                }
            }
        })
    }

    private func layout() {
        [logoImageView, profileTableView].forEach { view.addSubview($0) }
        
        logoImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.snp.topMargin)
            make.height.equalTo(120)
        }
        
        profileTableView.snp.makeConstraints { make in
//            make.top.equalTo(view.snp.topMargin)
//            make.bottom.equalTo(view.snp.bottomMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(profileModel.count * 60)
            make.centerY.equalTo(view.snp.centerY)
        }
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case profileModel.count - 1 :
            let cell: ProfileLogoutTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupCell(with: profileModel[indexPath.row])
            return cell
        default:
            let cell: ProfileSelectTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.setupCell(with: profileModel[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let sendDocumentsVC = SendDocumentsViewController()
            navigationController?.pushViewController(sendDocumentsVC, animated: true)
        case 1:
            let changePasswordVC = ChangePasswordViewController()
            navigationController?.pushViewController(changePasswordVC, animated: true)
        case 2:
            let dropPasswordVC = DropPasswordViewController()
            navigationController?.pushViewController(dropPasswordVC, animated: true)
        case 3:
            let deleteAccountVC = DeleteAccountViewController()
            navigationController?.pushViewController(deleteAccountVC, animated: true)
        case 4:
            showLogoutAlert()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}



// MARK: - Alert

private extension ProfileViewController {
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Вы точно хотите выйти из профиля?", message: nil, preferredStyle: .alert)
        
        let declineAction = UIAlertAction(title: "Отмена", style: .destructive)
        let okAction = UIAlertAction(title: "Выйти", style: .default) { [weak self] _ in
            self?.logout()
        }
        alert.addAction(okAction)
        alert.addAction(declineAction)
        
        present(alert, animated: true)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Произошла ошибка", message: "Попробуйте ещё раз", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
