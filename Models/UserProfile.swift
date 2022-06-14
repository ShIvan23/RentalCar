//
//  UserProfile.swift
//  RentalCar
//
//  Created by Ivan on 14.06.2022.
//

import Foundation

struct UserProfile: Decodable {
    let userName: String
    let name: String
    let email: String
    let phone: String
    let status: Int
    let isDocumentConfirm: Bool
    
    private enum CodingKeys: String, CodingKey {
        case name, email, phone, status
        case userName = "username"
        case isDocumentConfirm = "is_document_confirm"
    }
}
