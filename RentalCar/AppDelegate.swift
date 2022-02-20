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
//        window?.rootViewController = MainTabBarViewController()
        window?.rootViewController = OrderUnauthorizedViewController(carModel: CarModel(
            marka: "KIA",
            model: "Rio",
            age: 2019,
            personPrice: 2450,
            commercialPriceWithNDS: 4000,
            commercialPriceWithoutNDS: 3500,
            driverPriceImMoscow: 2000,
            driverPriceInOblast: 3000,
            previewImage: UIImage(named: "kiaRio")!,
            engineVolume: "123 л.с.",
            numberOfSeats: 5,
            frontDrive: "Передний",
            transmission: "Автомат",
            numberOfDoors: 4,
            hasConditioner: true,
            allImages: [UIImage(named: "kiaRio1")!, UIImage(named: "kiaRio2")!, UIImage(named: "kiaRio3")!, UIImage(named: "kiaRio4")!],
            description: """
Новый седан Киа Рио – универсальный современный автомобиль для ежедневных задач. Оптимальная компоновка салона и максимально продуманная организация пространства подарит комфорт каждому пассажиру. Будьте уверены — места хватит всем. Оригинальный рисунок оптики украшает вид автомобиля сзади, что делает его еще более стильным. А яркий свет сделает Вас заметным в потоке даже в самый солнечный день.
"""
        ))
        window?.makeKeyAndVisible()
        return true
    }

}

