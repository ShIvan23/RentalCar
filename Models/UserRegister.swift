//
//  UserRegister.swift
//  RentalCar
//
//  Created by Ivan on 16.04.2022.
//

import Foundation

struct UserRegister: Encodable {
    let name: String
    let phone: String
    let email: String
    let password: String
}

struct RegisterResult: Decodable {
    let success: Bool
}
