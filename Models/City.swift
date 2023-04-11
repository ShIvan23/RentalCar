//
//  City.swift
//  RentalCar
//
//  Created by Ivan on 28.03.2023.
//

import Foundation

struct City: Model, Decodable {
    let name: String
    let image: String
    let address: String
    let phoneNumber: String
    let whatsapp: String
    let telegram: String
    let email: String
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case name, address, whatsapp, telegram, email, latitude, longitude
        case image = "img"
        case phoneNumber = "phone"
    }
}

extension City {
    static func mockCityForLegal() -> City {
        City(name: "Москва",
             image: "",
             address: "",
             phoneNumber: "+79250709779",
             whatsapp: "",
             telegram: "",
             email: "",
             latitude: 0,
             longitude: 0)
    }
}
