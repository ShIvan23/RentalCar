//
//  UIViewController+Extension.swift
//  RentalCar
//
//  Created by Ivan on 20.02.2022.
//

import UIKit

extension UIViewController {
    // TODO: - функция используется в одном месте. Нужна ли она вообще?
    func makeCurrentPriceWith(_ category: CategoryPrice, car: CarModel2) -> Price? {
        switch category {
        case .personPrice:
            return car.price?.withoutNDS
        case.commercialPriceWithNDS:
            return car.price?.withNDS
        case .commercialPriceWithoutNDS:
            return car.price?.withoutNDS
        }
    }
    
    func call() {
        /// Телефон Реймера
        // TODO: - Поменять телефон
        let number = "+79265587363"
        guard let url = URL(string: "tel://\(number)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
