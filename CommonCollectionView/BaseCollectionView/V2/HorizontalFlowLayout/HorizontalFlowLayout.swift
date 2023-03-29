//
//  HorizontalFlowLayout.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

final class HorizontalFlowLayout: BaseFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - CGFloat.sideInset * 2
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}
