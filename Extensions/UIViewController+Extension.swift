//
//  UIViewController+Extension.swift
//  RentalCar
//
//  Created by Ivan on 20.02.2022.
//

import UIKit

extension UIViewController {
    func makeCurrentPriceWith(_ category: CategoryPrice, car: CarModel2) -> Int {
        switch category {
        case .personPrice:
            return car.price ?? 0
            
            // TODO: - Переделать на коммерческие прайсы
        case.commercialPriceWithNDS:
            return car.price ?? 0
        case .commercialPriceWithoutNDS:
            return car.price ?? 0
        }
    }
    
    func call() {
        /// Телефон Реймера
        let number = "+79265587363"
        guard let url = URL(string: "tel://\(number)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
