//
//  AllCarsFlowLayout.swift
//  RentalCar
//
//  Created by Ivan on 26.03.2023.
//

import UIKit

final class AllCategoryDelegate: VerticalFlowLayout {
    
    override var model: [Model] {
        get { return categoryModel }
        set {
            guard let categoryModel = newValue as? [CarClass2] else { return }
            self.categoryModel = categoryModel
        }
    }
    
    private var categoryModel: [CarClass2] = []
    private var coordinator: ICoordinator
    private let city: CityNumber
    private let categoryPrice: CategoryPrice
    
    init(
        coordinator: ICoordinator,
        categoryPrice: CategoryPrice,
        city: CityNumber
    ) {
        self.coordinator = coordinator
        self.categoryPrice = categoryPrice
        self.city = city
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.openCarCategory(
            with: categoryModel[indexPath.item].auto ?? [],
            title: categoryModel[indexPath.item].name ?? "",
            coordinator: coordinator,
            categoryPrice: categoryPrice,
            city: city)
        sendAnalyticEvent(indexPathItem: indexPath.item)
    }
    
    private func sendAnalyticEvent(indexPathItem: Int) {
        switch indexPathItem {
        case 0:
            AnalyticEvent.vipTapped.send()
        case 1:
            AnalyticEvent.businessTapped.send()
        case 2:
            AnalyticEvent.comfortTapped.send()
        case 3:
            AnalyticEvent.standartTapped.send()
        default:
            break
        }
    }
}
