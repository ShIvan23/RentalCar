//
//  CarModel.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

protocol Model {}

// Модель списка машин

struct CarsModel: Decodable {
    let data: [CarClass2]
}

struct CarClass2: Model, Decodable {
    let name: String?
    let image: String?
    let auto: [CarModel2]?
}

struct CarClass: Model {
    
    static func makeMockLegalModel() -> [CarClass2] {
        var model = [CarClass2]()
        model.append(
            CarClass2(
                name: "С НДС",
                image: "withNDS",
                auto: []
            )
        )
        model.append(
            CarClass2(
                name: "Без НДС",
                image: "withoutNDS",
                auto: []
            )
        )
        
        return model
    }
}

struct CarModel2: Model, Codable {
    let id: Int?
    let name: String?
    let thumb: String?
    let images: [String]?
    let description: String?
    let model: String?
    let brand: String?
    let year: Int?
    let engineVolume: Double?
    let enginePower: Int?
//    let engineType: Bool
    let driveType: String?
    let gearboxType: String?
    let countSeats: Int?
    let countDoors: Int?
    let conditioner: Bool?
    let price: Int?
    let priceFrom3To6Days: Int?
    let priceFrom7To13Days: Int?
    let priceFrom14To29Days: Int?
    let priceMonth: Int?
    let priceWorkday: Int?
    let priceDriver: Int?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, thumb, images, description, model, brand, year, conditioner, price
        case engineVolume = "engine_volume"
        case enginePower = "engine_power"
//        case engineType = "engine_type"
        case driveType = "drive_type"
        case gearboxType = "gearbox_type"
        case countSeats = "count_seats"
        case countDoors = "count_doors"
        case priceDriver = "price_driver"
        case priceFrom3To6Days = "price_3_6"
        case priceFrom7To13Days = "price_7_13"
        case priceFrom14To29Days = "price_14_29"
        case priceMonth = "price_30"
        case priceWorkday = "price_workday"
    }
}
