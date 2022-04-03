//
//  OrderModel.swift
//  RentalCar
//
//  Created by Ivan on 03.04.2022.
//

import Foundation

struct Order: Encodable {
    // TODO: - изменить id на название машины
    let autoId: Int = 2
    let name: String = "Иван Иванов"
    let location: String = "Офис"
    let startRental: String = "2022-03-01"
    let endRental: String = "2022-03-01"
    let email: String? = nil
    let phone: String = "+79998887766"
    let needDriver: Bool = true
    let cost: Int = 100500
    
    private enum CodingKeys: String, CodingKey {
        case name, location, phone, cost, email
        case autoId = "auto_id"
        case startRental = "start_rental"
        case endRental = "end_rental"
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
