//
//  MainTabBarViewController.swift
//  RentalCar
//
//  Created by Ivan on 28.01.2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private lazy var allCars = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
        categoryPrice: .personPrice,
        model: CarClass.makeMockModel()
    )
    
    private lazy var legalEntity = BaseCollectionViewController(
        collectionStyle: .categoryStyle,
        model: CarClass.makeMockLegalModel(),
        isChooseLegal: true
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setControllers()
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
            createNavController(for: legalEntity, title: "Юр лица", image:  UIImage(named: "car2")!)
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }

}
