//
//  AppDelegate.swift
//  RentalCar
//
//  Created by Ivan on 25.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BaseCollectionViewController(collectionStyle: .defaultStyle, model: [])
        window?.makeKeyAndVisible()
        return true
    }

}

