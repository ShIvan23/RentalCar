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
    
    private enum CodingKeys: String, CodingKey {
        case name
        case image = "img"
    }
}
