//
//  AgainConfirmCode.swift
//  RentalCar
//
//  Created by Ivan on 16.04.2022.
//

import Foundation

struct AgainConfirmCode: Encodable {
    let email: String
}

struct AgainConfirmCodeResult: Decodable {
    let success: Bool
}
