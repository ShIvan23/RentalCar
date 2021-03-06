//
//  PromoModel.swift
//  RentalCar
//
//  Created by Ivan on 04.04.2022.
//

import Foundation

// Модель акций

struct PromoData: Model, Decodable {
    let name: String
    let thumb: String
    let promos: [Promo]
}

struct Promo: Model, Decodable {
    let title: String
    let thumb: String
}
