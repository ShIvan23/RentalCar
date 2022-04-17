//
//  Login.swift
//  RentalCar
//
//  Created by Ivan on 17.04.2022.
//

import Foundation

struct Login: Encodable {
    let email: String
    let password: String
}

struct LoginResult: Decodable {
    let success: Bool
}
