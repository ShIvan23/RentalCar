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
    func postLogin(body: Login) -> URLRequest?
    func postDocuments() -> String
    func postLogout() -> URLRequest?
    func postChangePassword(body: ChangePassword) -> URLRequest?
    func postDropPasswoed(body: DropPassword) -> URLRequest?
    func getUserProfile() -> URLRequest?
    func userDelete() -> URLRequest?
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
        static let login = "user/login"
        static let uploadDocument = "user/upload-document"
        static let logout = "user/logout"
        static let changePassword = "user/change-password"
        static let dropPassword = "user/restore-password"
        static let userProfile = "user/profile"
        static let userDelete = "user/delete"
    }

    private lazy var defaultHeader = [
        "Content-Type" : "application/json",
        "Accept" : "*/*"
    ]
    
    private lazy var logoutHeader = [
        "Accept" : "*/*",
        "Authorization" : "Bearer \(AppState.shared.token)"
    ]
    
    private lazy var changePasswordHeader = [
        "Accept" : "*/*",
        "Authorization" : "Bearer \(AppState.shared.token)",
        "Content-Type" : "application/json"
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
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
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
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
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
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
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
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
        }
        request.httpBody = data
        return request
    }
    
    func postLogin(body: Login) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.login) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = defaultHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
        }
        request.httpBody = data
        return request
    }
    
    func postDocuments() -> String {
        return baseUrlString + UrlStrings.uploadDocument
    }
    
    func postLogout() -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.logout) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = logoutHeader
        return request
    }
    
    func postChangePassword(body: ChangePassword) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.changePassword) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = changePasswordHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
        }
        request.httpBody = data
        return request
    }
    
    func postDropPasswoed(body: DropPassword) -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.dropPassword) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = changePasswordHeader
        guard let data = try? encoder.encode(body) else {
            fatalError("???? ???????????????????? ???????????????????????? ??????????????????")
        }
        request.httpBody = data
        return request
    }
    
    func getUserProfile() -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.userProfile) else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = logoutHeader
        return request
    }
    
    func userDelete() -> URLRequest? {
        guard let url = URL(string: baseUrlString + UrlStrings.userDelete) else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = logoutHeader
        return request
    }
}
