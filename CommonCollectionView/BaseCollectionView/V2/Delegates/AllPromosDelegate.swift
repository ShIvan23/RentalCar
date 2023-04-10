//
//  PromoDelegate.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class AllPromosDelegate: VerticalFlowLayoutForTwoItems {
    
    override var model: [Model] {
        get { return promosModel }
        set {
            guard let promosModel = newValue as? [PromoData] else { return }
            self.promosModel = promosModel
        }
    }
    
    private var promosModel: [PromoData] = []
    private var coordinator: ICoordinator
    
    init(coordinator: ICoordinator) {
        self.coordinator = coordinator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.navigationController = navigationController
        coordinator.openPromo(
            with: promosModel[indexPath.item].promos,
            title: promosModel[indexPath.item].name,
            coordinator: coordinator)
        indexPath.item == 0 ? AnalyticEvent.permanentPromo.send() : AnalyticEvent.promoOfMonth.send()
    }
}
