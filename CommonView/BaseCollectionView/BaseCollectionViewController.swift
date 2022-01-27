//
//  BaseCollectionViewController.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

class BaseCollectionViewController: UIViewController {
    
    enum CollectionStyle {
        case defaultStyle
        case twoCellsStyle
    }
    
    private let collectionStyle: CollectionStyle
    private let model: [CarModel]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cell: BaseCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(collectionStyle: CollectionStyle, model: [CarModel]) {
        self.collectionStyle = collectionStyle
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

// MARK: - UICollectionViewDataSource

extension BaseCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionStyle {
        case .twoCellsStyle:
            return 2
        case .defaultStyle:
            return 10
//            return model.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    private var sideInset: CGFloat { return 8 }
    private var cellHeight: CGFloat { return 260 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - sideInset * 3) / 2
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionStyle {
        case .twoCellsStyle:
            let midlleHeightScreen = (UIScreen.main.bounds.height - cellHeight) / 2
            return UIEdgeInsets(top: midlleHeightScreen, left: sideInset, bottom: sideInset, right: sideInset)
        case .defaultStyle:
            return UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
        }
    }
}
