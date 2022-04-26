//
//  ImageCollectionViewCell.swift
//  RentalCar
//
//  Created by Ivan on 05.02.2022.
//

import Kingfisher
import UIKit
import Photos
import SnapKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    private let carImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    func setupCellWith(asset: PHAsset) {
        layout()
        setupCell()
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { [weak self] image, _ in
            guard let image = image else { return }
            self?.carImageView.image = image
        }
    }
    
    func setupCellWith(image: UIImage) {
        layout()
        setupCell()
        carImageView.image = image
    }
    
    func setupCellWith(image: String) {
        layout()
        setupCell()
        let urlImage = URL(string: image)
        carImageView.kf.setImage(with: urlImage)
    }
    
    private func setupCell() {
        contentView.backgroundColor = .white
    }
    
    private func layout() {
        contentView.addSubview(carImageView)
        
        carImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
