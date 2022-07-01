//
//  AppError.swift
//  RentalCar
//
//  Created by Ivan on 13.06.2022.
//

import Foundation

enum AppError: Error {
    case error422(message: String)
    case error401(message: String)
    case error500(message: String)
}

extension AppError {
    func toString() -> String? {
        switch self {
        case .error422(let message):
            return message
        case .error401(let message):
            return message
        case .error500(let message):
            return message
        }
    }
}
