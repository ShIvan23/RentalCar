//
//  ApiValue.swift
//  RentalCar
//
//  Created by Ivan on 13.06.2022.
//

import Foundation

struct APIValue<T: Decodable>: Decodable {
    let success: Bool
    let message: String?
    var data: T?
}

struct APIDataMock: Decodable {}
