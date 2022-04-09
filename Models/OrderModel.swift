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
    let rentalDate: String
    let email: String? = nil
    let phone: String
    let needDriver: Bool
    let cost: Int
    
    private enum CodingKeys: String, CodingKey {
        case name, location, phone, cost, email
        case autoId = "auto_id"
        case rentalDate = "rental_date"
        case needDriver = "need_driver"
    }
}

struct OrderResult: Decodable {
    let success: Bool
    let data: OrderResultData
}

struct OrderResultData: Decodable {
    let name: String?
    let message: String?
    let code: Int?
    let status: Int?
}
