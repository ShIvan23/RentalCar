//
//  MainTabBarViewController.swift
//  RentalCar
//
//  Created by Ivan on 28.01.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let rentalManager = RentalManager()
    private var model: CarsModel? {
        didSet {
            setModelIntoControllers()
        }
    }
    
    private lazy var allCars = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
        categoryPrice: .personPrice
    )
    
    private lazy var legalEntity = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
//        model: CarClass.makeMockLegalModel(),
        isChooseLegal: true
    )
    
    private lazy var stockVC = BaseCollectionViewController(
        collectionStyle: .stockStyle,
//        model: InformationModel.makeMockStocks(),
        isChooseLegal: true
    )
    
    private lazy var rentalConditionsVC = BaseCollectionViewController(
        collectionStyle: .rentalCondition,
//        model: InformationModel.makeMockConditions(),
        isChooseConditions: true
    )
    
    private lazy var contactsVC = ContactsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setControllers()
        rentalManager.fetchCars { [weak self] result in
            switch result {
            case .success(let model):
                self?.model = model
            case .failure(let error):
                fatalError(error.localizedDescription)
//                print(error.localizedDescription)
            }
        }
    }
    
    private func setModelIntoControllers() {
        allCars.model = model?.data
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
            createNavController(for: stockVC, title: "Акции", image: UIImage(named: "stock")!),
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
