//
//  Coordinator.swift
//  RentalCar
//
//  Created by Ivan on 28.03.2023.
//

import UIKit

protocol ICoordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    
    func openCarCategories(with model: [Model], title: String, coordinator: ICoordinator, categoryPrice: CategoryPrice, city: City)
    func openCarCategory(with model: [Model], title: String, coordinator: ICoordinator, categoryPrice: CategoryPrice, city: City)
    func openProfile()
    func openLogin()
    func openDetailCar(with model: CarModel2, coordinator: ICoordinator, cityNumber: String)
    func openPromo(with model: [Model], title: String, coordinator: ICoordinator)
    func openCondition(with model: ConditionsModel)
    func openContact(with model: City)
}

final class Coordinator: ICoordinator {
    
    static let firstFlow: ICoordinator = Coordinator()
    static let secondFlow: ICoordinator = Coordinator()
    static let promoFlow: ICoordinator = Coordinator()
    static let conditionsFlow: ICoordinator = Coordinator()
    static let contactsFlow: ICoordinator = Coordinator()
    
    private init() {}
    
    var navigationController: UINavigationController?
    
    func openCarCategories(with model: [Model], title: String, coordinator: ICoordinator, categoryPrice: CategoryPrice, city: City) {
        let categoriesCollection = Builder.buildAllCategoriesCollection(coordinator: coordinator,
                                                                        categoryPrice: categoryPrice,
                                                                        city: city)
        categoriesCollection.title = title
        categoriesCollection.reloadData(with: model)
        navigationController?.pushViewController(categoriesCollection, animated: true)
    }
    
    func openCarCategory(with model: [Model], title: String, coordinator: ICoordinator, categoryPrice: CategoryPrice, city: City) {
        let categoryCollection = Builder.buildCategoryCollection(coordinator: coordinator,
                                                                 categoryPrice: categoryPrice,
                                                                 cityName: city.name,
                                                                 cityNumber: city.phoneNumber)
        categoryCollection.title = title
        categoryCollection.reloadData(with: model)
        navigationController?.pushViewController(categoryCollection, animated: true)
    }
    
    func openProfile() {
        let profileViewController = ProfileViewController()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    func openLogin() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func openDetailCar(with model: CarModel2, coordinator: ICoordinator, cityNumber: String) {
        let detailViewController = DetailCarViewController(carModel: model,
                                                           categoryPrice: .personPrice,
                                                           cityNumber: cityNumber)
        detailViewController.title = model.name
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func openPromo(with model: [Model], title: String, coordinator: ICoordinator) {
        let promoCollection = Builder.buildPromoCollection(coordinator: coordinator)
        promoCollection.title = title
        promoCollection.reloadData(with: model)
        navigationController?.pushViewController(promoCollection, animated: true)
    }
    
    func openCondition(with model: ConditionsModel) {
        let conditionViewController = ConditionViewController(model: model.conditions)
        conditionViewController.title = model.title
        navigationController?.pushViewController(conditionViewController, animated: true)
    }
    
    func openContact(with model: City) {
        let contactViewController = ContactsViewController(cityModel: model)
        contactViewController.title = model.name
        navigationController?.pushViewController(contactViewController, animated: true)
    }
}
