//
//  CarCategoryDelegate.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 03.04.2023.
//

import UIKit

final class CarCategoryDelegate: VerticalFlowLayout {
    
    override var model: [Model] {
        get { return carModel }
        set {
            guard let carModel = newValue as? [CarModel2] else { return }
            self.carModel = carModel
        }
    }
    
    private var carModel: [CarModel2] = []
    private var coordinator: ICoordinator
    private let city: CityNumber
    
    init(coordinator: ICoordinator,
         city: CityNumber) {
        self.coordinator = coordinator
        self.city = city
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.openDetailCar(
            with: carModel[indexPath.item],
            coordinator: coordinator,
            city: city)
        AnalyticEvent.userTappedCar(car: carModel[indexPath.item].name ?? "").send()
    }
}
