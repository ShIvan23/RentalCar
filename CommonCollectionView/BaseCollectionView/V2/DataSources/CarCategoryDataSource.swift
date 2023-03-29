//
//  AllCarsDataSource.swift
//  RentalCar
//
//  Created by Ivan on 25.03.2023.
//

import UIKit

final class CarCategoryDataSource: NSObject, IBaseDataSource {

    private(set) var model: [Model] = []
    
    func setupModel(_ model: [Model]) {
        guard let carModel = model as? [CarClass2] else {
            assertionFailure("Пришел не тот тип модели")
            return
        }
        self.model = carModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChooseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setupCell(model: model[indexPath.item])
        return cell
    }
}
