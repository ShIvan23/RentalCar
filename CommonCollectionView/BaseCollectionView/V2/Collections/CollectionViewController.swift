//
//  CollectionViewController.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import SnapKit

final class CollectionViewController: BaseCollectionViewControllerV2 {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    // MARK: - Private
    
    private func layout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }
}
