//
//  RequestManager.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import Foundation

protocol RequestManager {
    func getAllAuto() -> URLRequest?
    func postOrder(body: Order) -> URLRequest?
}

final class RequestManagerImp: RequestManager {
    
    private let allAutoUrlString = "https://api-prokat.tmweb.ru/auto"
    private lazy var orderUrlString = "https://api-prokat.tmweb.ru/order"
    private lazy var defaultHeader = [
        "Content-Type" : "application/json",
        "Accept" : "*/*"
    ]
    
    func getAllAuto() -> URLRequest? {
        guard let url = URL(string: allAutoUrlString) else { return nil }
        return URLRequest(url: url)
    }
    
    func postOrder(body: Order) -> URLRequest? {
        guard let url = URL(string: orderUrlString) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeader
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(body) else {
            fatalError("НЕ получилось закодировать структуру")
        }
        request.httpBody = data
        return request
    }
}
