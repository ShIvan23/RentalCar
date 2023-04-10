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
    private var coordinator: ICoordinator
    
    init(coordinator: ICoordinator) {
        self.coordinator = coordinator
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.navigationController = navigationController
        let currentCityNumber = setCurrentCityNumber(cityModel[indexPath.item].name)
        coordinator.openCarCategories(
            with: AppStorage.shared.carClasses,
            title: cityModel[indexPath.item].name,
            coordinator: coordinator,
            categoryPrice: .personPrice,
            city: currentCityNumber)
    }
    
    private func setCurrentCityNumber(_ city: String) -> CityNumber {
        switch city {
        case "Москва":
            return CityNumber.moscow
        case "Казань":
            return CityNumber.kazan
        default:
            return CityNumber.moscow
        }
    }
}
