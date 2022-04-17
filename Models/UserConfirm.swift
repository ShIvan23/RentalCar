//
//  UserConfirm.swift
//  RentalCar
//
//  Created by Ivan on 16.04.2022.
//

import Foundation

struct UserConfirm: Encodable {
    let email: String
    let code: Int
}

struct UserConfirmResult: Decodable {
    let success: Bool
}
