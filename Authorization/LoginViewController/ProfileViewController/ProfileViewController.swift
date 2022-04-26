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

final class ProfileViewController: UIViewController {
    
    // TODO: - Здесь нужно реализовать прикрепление фото
    
    private lazy var permissionManager = PermissionManager()
    
    private lazy var imagePicker = ImagePickerController()
    
    private var selectedAssets = [PHAsset]()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Чтобы оплатить машину из приложения, необходимо прикрепить фото паспорта (2-ая и 3-ая страницы) и водительского удостоверения с двух сторон"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
    }
    
    @objc private func sendPhotos() {
        print("send")
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

    private func layout() {
        [descriptionLabel, photosCollectionView, sendButton].forEach { view.addSubview($0) }
        
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
}
