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
    func getPromos() -> URLRequest?
    func postUserRegister(body: UserRegister) -> URLRequest?
    func postUserConfirm(body: UserConfirm) -> URLRequest?
    func postAgainConfirmCode(body: AgainConfirmCode) -> URLRequest?
}

final class RequestManagerImp: RequestManager {
    
    private let baseUrlString = "https://api-prokat.tmweb.ru/"
    private lazy var encoder = JSONEncoder()
    
    private enum UrlStrings {
        static let auto = "auto"
        static let order = "order"
        static let promo = "promo"
        static let userRegister = "user/register"
        static let userConfirm = "user/confirm-code"
        static let againConfirmCode = "user/send-confirm-code"
    }

    private lazy var defaultHeader = [
        "Content-Type" : "application/json",
        "Accept" : "*/*"
    ]
    
    func getAllAuto() -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.auto) else { return nil }
        return URLRequest(url: url)
    }
    
    func postOrder(body: Order) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.order) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("НЕ получилось закодировать структуру")
        }
        request.httpBody = data
        return request
    }
    
    func getPromos() -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.promo) else { return nil }
        return URLRequest(url: url)
    }
    
    func postUserRegister(body: UserRegister) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.userRegister) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("НЕ получилось закодировать структуру")
        }
        request.httpBody = data
        return request
    }
    
    func postUserConfirm(body: UserConfirm) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.userConfirm) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("НЕ получилось закодировать структуру")
        }
        request.httpBody = data
        return request
    }
    
    func postAgainConfirmCode(body: AgainConfirmCode) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.againConfirmCode) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("НЕ получилось закодировать структуру")
        }
        request.httpBody = data
        return request
    }
}
