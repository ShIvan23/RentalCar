//
//  CityContactsDelegate.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 04.04.2023.
//

import UIKit

final class CityContactsDelegate: VerticalFlowLayoutForTwoItems {
    
    override var model: [Model] {
        get { return cityModel }
        set {
            guard let cityModel = newValue as? [City] else { return }
            self.cityModel = cityModel
        }
    }
    
    private var cityModel: [City] = []
    private var coordinator: ICoordinator
    
    init(coordinator: ICoordinator) {
        self.coordinator = coordinator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.navigationController = navigationController
        coordinator.openContact(with: AppStorage.shared.contacts[indexPath.item])
    }
}
