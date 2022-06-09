//
//  ChangePassword.swift
//  RentalCar
//
//  Created by Ivan on 01.06.2022.
//

import Foundation

struct ChangePassword: Encodable {
    let oldPassword: String
    let newPassword: String
    
    private enum CodingKeys: String, CodingKey {
        case oldPassword = "old_password"
        case newPassword = "new_password"
    }
}

struct ChangePasswordResult: Decodable {
    let success: Bool
    let data: ChangePasswordResultData?
}

struct ChangePasswordResultData: Decodable {
    let message: String?
    let code: Int?
}
