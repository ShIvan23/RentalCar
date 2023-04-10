//
//  PromoDataSource.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class PromoDataSource: NSObject, IBaseDataSource {
 
    private(set) var model: [Model] = []
    
    func setupModel(_ model: [Model]) {
        guard let promoModel = model as? [Promo] else {
            assertionFailure("Пришел не тот тип модели")
            return
        }
        self.model = promoModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.isEmpty ? 1 : model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if model.isEmpty {
            let cell: EmptyStockCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            return cell
        } else {
            let cell: StockCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setupCell(model: model[indexPath.item])
            return cell
        }
    }
}
