//
//  LegalDataSource.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class LegalDataSource: NSObject, IBaseDataSource {
    
    private(set) var model: [Model] = []
    
    func setupModel(_ model: [Model]) {
        guard let legalModel = model as? [CommercialModel] else {
            assertionFailure("Пришел не тот тип модели")
            return
        }
        self.model = legalModel
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
