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

struct LoginResultData: Decodable {
    let token: String
    let refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
        case token
        case refreshToken = "refresh_token"
    }
}
