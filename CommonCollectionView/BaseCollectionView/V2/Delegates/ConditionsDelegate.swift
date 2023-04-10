//
//  ConditionsDelegate.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class ConditionsDelegate: VerticalFlowLayoutForTwoItems {
    
    override var model: [Model] {
        get { return conditionsModel }
        set {
            guard let conditionsModel = newValue as? [ConditionsModel] else { return }
            self.conditionsModel = conditionsModel
        }
    }
    
    private var conditionsModel: [ConditionsModel] = []
    private var coordinator: ICoordinator
    
    init(coordinator: ICoordinator) {
        self.coordinator = coordinator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.navigationController = navigationController
        coordinator.openCondition(with: conditionsModel[indexPath.item])
        indexPath.item == 0 ? AnalyticEvent.personCondition.send() : AnalyticEvent.commercialCondition.send()
    }
}
