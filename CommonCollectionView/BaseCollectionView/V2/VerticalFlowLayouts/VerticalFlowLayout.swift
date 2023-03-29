//
//  BaseVerticalFlowLayout.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

class VerticalFlowLayout: BaseFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat.sideInset,
                            left: CGFloat.sideInset,
                            bottom: CGFloat.sideInset,
                            right: CGFloat.sideInset)
    }
}
