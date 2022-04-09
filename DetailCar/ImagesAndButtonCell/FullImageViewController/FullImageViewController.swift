//
//  FullImageViewController.swift
//  RentalCar
//
//  Created by Ivan on 09.04.2022.
//

import Kingfisher
import UIKit
import SnapKit

final class FullImageViewController: UIViewController {
    
    private var currentImage: UIImage? {
        didSet {
            guard let currentImage = currentImage else { return }
            layout()
            setupView()
            scrollView.set(image: currentImage)
        }
    }
    
    lazy var scrollView = ImageScrollView(frame: view.bounds)
    
    private let photoImageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .yellow
        return $0
    } (UIImageView())
    
    private lazy var backButton: UIButton = {
        $0.setImage(UIImage(named: "cross"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    init(image: String) {
        super.init(nibName: nil, bundle: nil)
        setImage(name: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImage(name: String) {
        let imageUrl = URL(string: name)
        photoImageView.kf.setImage(with: imageUrl) { [weak self] result in
            switch result {
            case .success(let value):
                self?.currentImage = value.image
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func layout() {
        [scrollView, backButton].forEach { view.addSubview($0) }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).inset(10)
            make.right.equalToSuperview().inset(15)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true)
    }
}
