//
//  CityDelegate.swift
//  RentalCar
//
//  Created by Ivan on 28.03.2023.
//

import UIKit

final class CityDelegate: VerticalFlowLayoutForTwoItems {
    
    override var model: [Model] {
        get { return cityModel }
        set {
            guard let cityModel = newValue as? [City] else { return }
            self.cityModel = cityModel
        }
    }
    
    private var cityModel: [City] = []
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("+++ select indexPath.item", indexPath.item)
        print("+++ model = \(model)")
    }
}
