//
//  OrderModel.swift
//  RentalCar
//
//  Created by Ivan on 03.04.2022.
//

import Foundation

// Модель отправки заказа

struct Order: Encodable {
    let autoId: Int
    let name: String
    let location: String
    let city: String
    let comment: String
    let rentalDate: String
    let email: String = AppState.shared.userEmail
    let phone: String
    let needDriver: Bool
    let cost: Int
    
    private enum CodingKeys: String, CodingKey {
        case name, location, city, comment, phone, cost, email
        case autoId = "auto_id"
        case rentalDate = "rental_date"
        case needDriver = "need_driver"
    }
}

struct OrderResultData: Decodable {
    let name: String?
    let message: String?
    let code: Int?
    let status: Int?
}
