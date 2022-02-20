//
//  UIViewController+Extension.swift
//  RentalCar
//
//  Created by Ivan on 20.02.2022.
//

import UIKit

extension UIViewController {
    func makeCurrentPriceWith(_ category: CategoryPrice, car: CarModel) -> Int {
        switch category {
        case .personPrice:
            return car.personPrice
        case.commercialPriceWithNDS:
            return car.commercialPriceWithNDS
        case .commercialPriceWithoutNDS:
            return car.commercialPriceWithoutNDS
        }
    }
}
