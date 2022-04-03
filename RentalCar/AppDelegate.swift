//
//  AppDelegate.swift
//  RentalCar
//
//  Created by Ivan on 25.01.2022.
//

import YandexMapsMobile
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupYandexMaps()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    private func setupYandexMaps() {
        YMKMapKit.setApiKey("562570cd-9220-4b25-bca2-be3259c844d5")
    }

}

