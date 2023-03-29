//
//  AllCarsFlowLayout.swift
//  RentalCar
//
//  Created by Ivan on 26.03.2023.
//

import UIKit

final class CarCategoryDelegate: VerticalFlowLayout {
    
    override var model: [Model] {
        get { return categoryModel }
        set {
            guard let categoryModel = newValue as? [CarClass2] else { return }
            self.categoryModel = categoryModel
        }
    }
    
    private var categoryModel: [CarClass2] = []
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select", categoryModel[indexPath.item].name)
    }
}
