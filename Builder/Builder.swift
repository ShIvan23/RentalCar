//
//  Builder.swift
//  RentalCar
//
//  Created by Ivan on 26.03.2023.
//

import UIKit

final class Builder {
    
    static func buildCityCollection(coordinator: ICoordinator) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = CityDataSource()
        let delegate = CityDelegate(coordinator: coordinator)
        let cityViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator)
        
        return cityViewController
    }
    
    static func buildAllCategoriesCollection(coordinator: ICoordinator, categoryPrice: CategoryPrice, city: City) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = AllCategoryDataSource()
        let delegate: IBaseFlowLayout = AllCategoryDelegate(coordinator: coordinator,
                                                            categoryPrice: categoryPrice,
                                                            city: city)
        let allCategoryViewController: IBaseCollectionViewControllerV2 = CollectionAndSearchViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator,
            categoryPrice: categoryPrice)
        
        allCategoryViewController.city = city
        
        return allCategoryViewController
    }
    
    static func buildCategoryCollection(coordinator: ICoordinator, categoryPrice: CategoryPrice, cityName: String, cityNumber: String) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = CarCategoryDataSource(categoryPrice: categoryPrice,
                                                                cityName: cityName)
        let delegate: IBaseFlowLayout = CarCategoryDelegate(coordinator: coordinator,
                                                            cityNumber: cityNumber)
        let carCategoryViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator,
            categoryPrice: categoryPrice)
        
        return carCategoryViewController
    }
    
    static func buildChoseLegalCollection(coordinator: ICoordinator, city: City, categoryPrice: CategoryPrice) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = LegalDataSource()
        let delegate: IBaseFlowLayout = LegalDelegate(coordinator: coordinator,
                                                      city: city)
        let chooseLegalViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator,
            categoryPrice: categoryPrice)
        
        return chooseLegalViewController
    }
    
    static func buildAllPromosCollection(coordinator: ICoordinator) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = AllPromosDataSource()
        let delegate: IBaseFlowLayout = AllPromosDelegate(coordinator: coordinator)
        let allPromosViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator)
        
        return allPromosViewController
    }
    
    static func buildPromoCollection(coordinator: ICoordinator) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = PromoDataSource()
        let delegate: IBaseFlowLayout = PromoDelegate(coordinator: coordinator)
        let promoViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator)
        
        return promoViewController
    }
    
    static func buildConditionsCollection(coordinator: ICoordinator) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = ConditionsDataSource()
        let delegate: IBaseFlowLayout = ConditionsDelegate(coordinator: coordinator)
        let conditionViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator)
        
        conditionViewController.reloadData(with: AppStorage.shared.conditions)
        
        return conditionViewController
    }
    
    static func buildCityContactsCollection(coordinator: ICoordinator) -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = CityContactsDataSource()
        let delegate: IBaseFlowLayout = CityContactsDelegate(coordinator: coordinator)
        let cityContactsViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate,
            coordinator: coordinator)
        
        return cityContactsViewController
    }
}
