//
//  MainTabBarViewController.swift
//  RentalCar
//
//  Created by Ivan on 28.01.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private enum FetchError {
        case cars
        case promo
    }
    
    private let rentalManager: RentalManager = RentalManagerImp()
    private var model: CarsModel? {
        didSet {
            setModelIntoControllers()
        }
    }
    
    private var promoModel: Promos? {
        didSet {
            setPromoModelIntoController()
        }
    }
    
    /// Физ лица
    private lazy var allCars = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
        categoryPrice: .personPrice
    )
    
    /// Юр лица
    private lazy var legalEntity = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
        isChooseLegal: true
    )
    
    /// Акции
    private lazy var promoVC = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
        isChoosePromo: true
    )
    
    /// Условия
    private lazy var rentalConditionsVC = BaseCollectionViewController(
        collectionStyle: .rentalCondition,
        isChooseConditions: true
    )
    
    /// Контакты
    private lazy var contactsVC = ContactsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setControllers()
        fetchCars()
        fetchPromos()
    }
    
    private func fetchCars() {
        rentalManager.fetchCars { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(error: .cars)
                }
            }
        }
    }
    
    private func fetchPromos() {
        rentalManager.fetchPromos { [weak self] result in
            switch result {
            case .success(let promos):
                self?.promoModel = promos
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showAlert(error: .promo)
                }
            }
        }
    }
    
    private func setModelIntoControllers() {
        allCars.model = model?.data
        
        legalEntity.model = CarClass.makeMockLegalModel()
        legalEntity.modelForPresenting = model?.data
    }
    
    private func setPromoModelIntoController() {
        promoVC.model = promoModel?.data
    }
    
    private func showAlert(error: FetchError) {
        let alert = UIAlertController(title: "Не получилось загрузить данные", message: "Возможно, нет подключения к интернету. Попробуйте еще раз.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Обновить", style: .default) { [weak self] _ in
            switch error {
            case .cars:
                self?.fetchCars()
            case .promo:
                self?.fetchPromos()
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
            createNavController(for: allCars, title: "Физ лица", image: UIImage(named: "car2")!),
            createNavController(for: legalEntity, title: "Юр лица", image:  UIImage(named: "car2")!),
            createNavController(for: promoVC, title: "Акции", image: UIImage(named: "stock")!),
            createNavController(for: rentalConditionsVC, title: "Условия", image: UIImage(named: "accept")!),
            createNavController(for: contactsVC, title: "Контакты", image: UIImage(named: "phone")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
//        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }

}
