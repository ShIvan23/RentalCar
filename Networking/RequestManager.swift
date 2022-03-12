//
//  RequestManager.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import Foundation

final class RequestManager {
    
    private let allAutoURLString = "https://api-prokat.tmweb.ru/auto"
    
    func getAllAuto() -> URLRequest? {
        guard let url = URL(string: allAutoURLString) else { return nil }
        return URLRequest(url: url)
    }
}
