//
//  Builder.swift
//  RentalCar
//
//  Created by Ivan on 26.03.2023.
//

import UIKit

protocol IBuilder {
    func buildCarCategoryCollection() -> IBaseCollectionViewControllerV2
    func buildCityCollection() -> IBaseCollectionViewControllerV2
}

final class Builder: IBuilder {
    
    func buildCarCategoryCollection() -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = CarCategoryDataSource()
        let delegate: IBaseFlowLayout = CarCategoryDelegate()
        let carCategoryViewController: IBaseCollectionViewControllerV2 = CollectionAndSearchViewController(
            dataSource: dataSource,
            delegate: delegate)
        
        return carCategoryViewController
    }
    
    func buildCityCollection() -> IBaseCollectionViewControllerV2 {
        let dataSource: IBaseDataSource = CityDataSource()
        let delegate: IBaseFlowLayout = CityDelegate()
        let cityViewController: IBaseCollectionViewControllerV2 = CollectionViewController(
            dataSource: dataSource,
            delegate: delegate)
        
        return cityViewController
    }
}
