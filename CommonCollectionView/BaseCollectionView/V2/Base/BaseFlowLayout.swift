//
//  BaseFlowLayout.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

protocol IBaseFlowLayout where Self: UICollectionViewDelegateFlowLayout {
    var model: [Model] { get set }
    var navigationController: UINavigationController? { get set }
    func setupModel(_: [Model])
}

extension IBaseFlowLayout {
    func setupModel(_ model: [Model]) {
        self.model = model
    }
}

class BaseFlowLayout: NSObject, IBaseFlowLayout {
    var navigationController: UINavigationController?
   
    var model: [Model] = []

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.sideInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - CGFloat.sideInset * 3) / 2
        return CGSize(width: width, height: CGFloat.cellHeight)
    }
}
