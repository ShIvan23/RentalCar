//
//  CarModel.swift
//  RentalCar
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

protocol Model {}

// Модель списка машин

struct CarClass2: Model, Decodable {
    let name: String?
    let image: String?
    let auto: [CarModel2]?
}

struct CarModel2: Model, Decodable {
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
    let price: Prices?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, thumb, images, description, model, brand, year, conditioner, price
        case engineVolume = "engine_volume"
        case enginePower = "engine_power"
//        case engineType = "engine_type"
        case driveType = "drive_type"
        case gearboxType = "gearbox_type"
        case countSeats = "count_seats"
        case countDoors = "count_doors"
    }
}

struct Prices: Model, Decodable {
    let withNDS: Price?
    let withoutNDS: Price?
}

struct Price: Model, Decodable {
    let price: Int?
    let priceFrom3To6Days: Int?
    let priceFrom7To13Days: Int?
    let priceFrom14To29Days: Int?
    let priceMonth: Int?
    let priceWorkday: Int?
    let priceDriver: Int?
    
    private enum CodingKeys: String, CodingKey {
        case price
        case priceFrom3To6Days = "price_3_6"
        case priceFrom7To13Days = "price_7_13"
        case priceFrom14To29Days = "price_14_29"
        case priceMonth = "price_30"
        case priceWorkday = "price_workday"
        case priceDriver = "price_driver"
    }
}

struct CommercialModel: Model {
    
    let name: String
    let image: UIImage
    let carClass: [CarClass2]?
    
    static func makeCommercialModel(cars: [CarClass2]?) -> [CommercialModel] {
        var model = [CommercialModel]()

        model.append(
            CommercialModel(
                name: "С НДС",
                image: UIImage(named: "withNDS")!,
                carClass: cars
            )
        )
        model.append(
            CommercialModel(
                name: "Без НДС",
                image: UIImage(named: "withoutNDS")!,
                carClass: cars
            )
        )
        
        return model
    }
}
