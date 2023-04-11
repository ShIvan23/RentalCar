//
//  MainTabBarViewController.swift
//  RentalCar
//
//  Created by Ivan on 28.01.2022.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    private enum FetchError {
        case cars
        case promo
        case city
    }
    
    private let rentalManager: RentalManager = RentalManagerImp()

    /// Физ лица
    private lazy var cityViewController = Builder.buildCityCollection(coordinator: Coordinator.firstFlow)
    
    /// Юр лица
    private lazy var chooseLegalViewController = Builder.buildChoseLegalCollection(coordinator: Coordinator.secondFlow,
                                                                                   city: CityNumber.moscow,
                                                                                   categoryPrice: .commercialPriceWithNDS)
    
    /// Акции
    private lazy var promoViewController = Builder.buildAllPromosCollection(coordinator: Coordinator.promoFlow)
    
    /// Условия
    private lazy var conditionsViewController = Builder.buildConditionsCollection(coordinator: Coordinator.conditionsFlow)
    
    /// Контакты
    private lazy var cityContactsViewController = Builder.buildCityContactsCollection(coordinator: Coordinator.contactsFlow)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setControllers()
        fetchCities()
        fetchCars()
        fetchPromos()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.title {
        case "Физ лица":
            AnalyticEvent.personTapped.send()
        case "Юр лица":
            AnalyticEvent.commercialTapped.send()
        case "Акции":
            AnalyticEvent.promoTapped.send()
        case "Условия":
            AnalyticEvent.conditionTapped.send()
        case "Контакты":
            AnalyticEvent.contactTapped.send()
        default:
            break
        }
    }
    
    private func fetchCars() {
        rentalManager.fetchCars { [weak self] result in
            switch result {
            case .success(let model):
                AppStorage.shared.updateClasses(model)
                let legalModel = AppStorage.shared.legal
                self?.chooseLegalViewController.reloadData(with: legalModel)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(error: .cars, message: error.toString() ?? "")
                }
            }
        }
    }
    
    private func fetchPromos() {
        rentalManager.fetchPromos { [weak self] result in
            switch result {
            case .success(let promos):
                AppStorage.shared.updatePromo(promos)
                self?.promoViewController.reloadData(with: promos)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(error: .promo, message: error.toString() ?? "")
                }
            }
        }
    }
    
    private func fetchCities() {
        cityViewController.lockView()
        rentalManager.fetchCities { [weak self] result in
            DispatchQueue.main.async {
                self?.cityViewController.unlock()
            }
            switch result {
            case .success(let model):
                AppStorage.shared.updateCities(model)
                self?.cityViewController.reloadData(with: model)
                self?.cityContactsViewController.reloadData(with: model)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(error: .city, message: error.toString() ?? "")
                }
            }
        }
    }
    
    private func showAlert(error: FetchError, message: String) {
        let alert = UIAlertController(title: "Не получилось загрузить данные", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Обновить", style: .default) { [weak self] _ in
            switch error {
            case .cars:
                self?.fetchCars()
            case .promo:
                self?.fetchPromos()
            case .city:
                self?.fetchCities()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func setupTabBar() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], for: .normal)
        tabBar.tintColor = .label
    }
    
    private func setControllers() {
        viewControllers = [
            createNavController(for: cityViewController, title: "Физ лица", image: UIImage(named: "car2")!),
            createNavController(for: chooseLegalViewController, title: "Юр лица", image: UIImage(named: "car2")!),
            createNavController(for: promoViewController, title: "Акции", image: UIImage(named: "stock")!),
            createNavController(for: conditionsViewController, title: "Условия", image: UIImage(named: "accept")!),
            createNavController(for: cityContactsViewController, title: "Контакты", image: UIImage(named: "phone")!)
        ]
    }
    
    private func createNavController(for rootViewController: IBaseCollectionViewControllerV2, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        rootViewController.delegate.navigationController = navController
        return navController
    }
}
