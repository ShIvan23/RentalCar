//
//  LegalDelegate.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class LegalDelegate: VerticalFlowLayoutForTwoItems {
    
    override var model: [Model] {
        get { return legalModel }
        set {
            guard let legalModel = newValue as? [CommercialModel] else { return }
            self.legalModel = legalModel
        }
    }
    
    private var legalModel: [CommercialModel] = []
    private var coordinator: ICoordinator
    private let city: City
    
    init(
        coordinator: ICoordinator,
        city: City
    ) {
        self.coordinator = coordinator
        self.city = city
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.navigationController = navigationController
        guard let carModel = legalModel[indexPath.item].carClass else {
            assertionFailure("Нет модели")
            return
        }
        coordinator.openCarCategories(
            with: carModel,
            title: legalModel[indexPath.item].name,
            coordinator: coordinator,
            categoryPrice: .commercialPriceWithNDS,
            city: city)
        indexPath.item == 0 ? AnalyticEvent.withNDSTapped.send() : AnalyticEvent.withoutNDSTapped.send()
    }
}
