//
//  CarCategoryDataSource.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 03.04.2023.
//

import UIKit

final class CarCategoryDataSource: NSObject, IBaseDataSource {
    
    private(set) var model: [Model] = []
    private let categoryPrice: CategoryPrice
    private let city: CityNumber
    
    init(
        categoryPrice: CategoryPrice,
        city: CityNumber
    ) {
        self.categoryPrice = categoryPrice
        self.city = city
    }
    
    func setupModel(_ model: [Model]) {
        guard let carModel = model as? [CarModel2] else {
            assertionFailure("Пришел не тот тип модели")
            return
        }
        self.model = carModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BaseCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setupCell(model: model[indexPath.item],
                       categoryPrice: categoryPrice,
                       city: city)
        return cell
    }
}
