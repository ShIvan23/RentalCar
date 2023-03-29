//
//  VerticalFlowLayoutForTwoItems.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

class VerticalFlowLayoutForTwoItems: BaseFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let middleHeightScreen = (ScreenSize.height - CGFloat.cellHeight) / 3
        return UIEdgeInsets(top: middleHeightScreen,
                            left: CGFloat.sideInset,
                            bottom: CGFloat.sideInset,
                            right: CGFloat.sideInset)
    }
}
