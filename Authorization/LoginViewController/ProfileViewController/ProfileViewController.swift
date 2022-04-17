//
//  ProfileViewController.swift
//  RentalCar
//
//  Created by Ivan on 10.04.2022.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController {
    
    // TODO: - Здесь нужно реализовать прикрепление фото
    
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
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: ImageCollectionViewCell.self)
//        collectionView.backgroundColor = .red
        return collectionView
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

    private func layout() {
        [descriptionLabel, photosCollectionView].forEach { view.addSubview($0) }
        
        photosCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(photosCollectionView.snp.top).offset(-30)
            make.left.right.equalToSuperview().inset(16)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setupCellWith(image: UIImage(named: "plus")!)
        return cell
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
            print("Открыть пикер")
        default:
            print("Открыть фото")
        }
    }
}
