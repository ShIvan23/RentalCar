//
//  SendDocumentsViewController.swift
//  RentalCar
//
//  Created by Ivan on 31.05.2022.
//

import BSImagePicker
import SnapKit
import Photos
import UIKit

final class SendDocumentsViewController: UIViewController, ToastViewShowable {
    
    var showingToast: ToastView?
    
    private lazy var imagePicker = ImagePickerController()
    private lazy var permissionManager = PermissionManager()
    private lazy var rentalManager = RentalManagerImp()
    private var selectedPhotos = [UIImage]()
    
    private var selectedAssets = [PHAsset]() {
        didSet {
            convertAssets()
        }
    }
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "Чтобы оплатить машину из приложения, необходимо прикрепить фото паспорта (2-ая и 3-ая страницы) и фото водительского удостоверения с двух сторон"
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
        collectionView.backgroundColor = .white
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
        layout()
        customize()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sendButton.setCustomGradient()
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
    
    private func showGallery() {
        presentImagePicker(imagePicker) {_ in} deselect: {_ in} cancel: {_ in} finish: { [weak self] assets in
            self?.selectedAssets = assets
            self?.photosCollectionView.reloadData()
        }
    }
    
    private func customize() {
        view.backgroundColor = .white
        title = "Отправить документы"
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

extension SendDocumentsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedPhotos.isEmpty {
            return 4
        } else {
            return selectedAssets.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        if selectedPhotos.isEmpty {
            switch indexPath.item {
            case 0:
                cell.setupCellWith(image: UIImage(named: "plus")!)
                return cell
            default :
                cell.setupCellWith(image: UIImage(named: "emptyPhoto")!)
                return cell
            }
        } else {
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SendDocumentsViewController: UICollectionViewDelegateFlowLayout {
    
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

private extension SendDocumentsViewController {
    
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
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Произошла ошибка", message: "Попробуйте ещё раз", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Хорошо", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
