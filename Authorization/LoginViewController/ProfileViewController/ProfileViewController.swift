//
//  ProfileViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit
import BSImagePicker
import Photos

final class ProfileViewController: UIViewController, ToastViewShowable {
    
    var showingToast: ToastView?
    
    // TODO: - Здесь кнопка для смены пароля
    // TODO: - Обновление token по refreshToken
    
    private lazy var permissionManager = PermissionManager()
    private lazy var rentalManager = RentalManagerImp()
    
    private lazy var imagePicker = ImagePickerController()
    
    private var selectedAssets = [PHAsset]() {
        didSet {
            convertAssets()
        }
    }
    
    private var selectedPhotos = [UIImage]()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Чтобы оплатить машину из приложения, необходимо прикрепить фото паспорта (2-ая и 3-ая страницы) и водительского удостоверения с двух сторон"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Выйти из профиля", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(logoutButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: ImageCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSAttributedString(string: "Отправить фото", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendPhotos), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.setCustomGradient()
        logoutButton.setCustomGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: - После логирования, нужно выходить на главный экран 
        if isMovingToParent,
           AppState.shared.userWasLogin {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc private func logoutButtonAction() {
        showLogoutAlert()
    }
    
    @objc private func sendPhotos() {
        var images = [UIImage]()
        selectedAssets.forEach {
            PHImageManager.default().requestImage(for: $0, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { image, _ in
                guard let image = image else { return }
                images.append(image)
            }
        }
        print("images.count отдаем = \(images.count)")
        print("картинки = \(images)")
        rentalManager.postImages(images) { [weak self] result in
            switch result.result {
            case .success(let model):
                print("model = \(model)")
                print("Документы отправлены на сервер. Показать алерт")
                self?.showSuccessToast(with: "Фото отправлены")
            case .failure(let error):
                print("error = \(error)")
                print("error.localizedDescription = \(error.localizedDescription)")
                self?.showErrorAlert()
            }
        }
    }
    
    private func convertAssets() {
        selectedAssets.forEach {
            PHImageManager.default().requestImage(for: $0, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { [weak self] image, _ in
                guard let image = image else { return }
                self?.selectedPhotos.append(image)
            }
        }
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Профиль"
    }
    
    private func showGallery() {
        presentImagePicker(imagePicker) {_ in} deselect: {_ in} cancel: {_ in} finish: { [weak self] assets in
            self?.selectedAssets = assets
            self?.photosCollectionView.reloadData()
        }
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
        [logoutButton ,descriptionLabel, photosCollectionView, sendButton].forEach { view.addSubview($0) }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(20)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(190)
        }
        
        photosCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(photosCollectionView.snp.top).offset(-30)
            make.left.right.equalToSuperview().inset(16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(photosCollectionView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        switch indexPath.item {
        case 0:
            cell.setupCellWith(image: UIImage(named: "plus")!)
            return cell
        default :
            cell.setupCellWith(asset: selectedAssets[indexPath.item - 1])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            permissionManager.requestPhotoLibrary { [weak self] in
                guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
                self?.showGallery()
            } failure: { [weak self] in
                self?.showPermissionAlert(with: .photo)
            }
        default:
//            let fullImageVC = FullImageViewController(image: selectedPhotos[indexPath.item])
//            navigationController?.pushViewController(fullImageVC, animated: true)
            break
        }
    }
}

// MARK: - Alert

private extension ProfileViewController {
    enum AlertText: String {
        case camera = "камере"
        case photo = "галерии"
    }
    
    func showPermissionAlert(with text: AlertText) {
        let alert = UIAlertController(title: "Вы отключили разрешение", message: "Для правильной работы приложения, разрешите доступ к " + text.rawValue, preferredStyle: .alert)
        
        let declineAction = UIAlertAction(title: "Позже", style: .destructive)
        let okAction = UIAlertAction(title: "В настройки", style: .default) { _ in
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingUrl) else { return }
            UIApplication.shared.open(settingUrl)
        }
        alert.addAction(declineAction)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
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
