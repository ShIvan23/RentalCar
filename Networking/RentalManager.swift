//
//  RentalManager.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import Alamofire
import Foundation
import UIKit

// TODO: - При переходе на networkAlamofire, нужно менять модель ответа на ResultData
protocol RentalManager {
    func fetchCars(completion: @escaping (Result<[CarClass2], AppError>) -> Void)
    func postOrder(order: Order, completion: @escaping (Result<OrderResultData, AppError>) -> Void)
    func fetchPromos(completion: @escaping (Result<[PromoData], AppError>) -> Void)
    func postRegisterUser(user: UserRegister, completion: @escaping (Result<RegisterResult, Error>) -> Void)
    func postConfirmUser(user: UserConfirm, completion: @escaping (Result<UserConfirmResult, Error>) -> Void)
    func postAgainConfirmCode(user: AgainConfirmCode, completion: @escaping (Result<AgainConfirmCodeResult, Error>) -> Void)
    func login(user: Login, completion: @escaping (Result<LoginResultData, AppError>) -> Void)
    func postImages(_ images: [Data], progress: @escaping ((Double) -> Void), completion: @escaping (Result<APIDataMock, AppError>) -> Void)
    func logout(completion: @escaping (Result<Logout, Error>) -> Void)
    func postChangePwassword(password: ChangePassword, completion: @escaping (Result<ChangePasswordResult, AppError>) -> Void)
    func postDropPassword(email: DropPassword, completion: @escaping (Result<DropPasswordResult, AppError>) -> Void)
    func getUserProfile(completion: @escaping (Result<UserProfile, AppError>) -> Void)
    func deleteUser(completion: @escaping (Result<UserDelete, AppError>) -> Void)
    func fetchCities(completion: @escaping (Result<[City], AppError>) -> Void)
}

final class RentalManagerImp: RentalManager {
    
    private let networkManager: NetworkManager = NetworkManagerImp()
    private let networkAlamofire: NetworkManager = NetworkAlamofire()
    private let requestManager: RequestManager = RequestManagerImp()
    
    func fetchCars(completion: @escaping (Result<[CarClass2], AppError>) -> Void) {
        guard let request = requestManager.getAllAuto() else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func postOrder(order: Order, completion: @escaping (Result<OrderResultData, AppError>) -> Void) {
        guard let request = requestManager.postOrder(body: order) else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func fetchPromos(completion: @escaping (Result<[PromoData], AppError>) -> Void) {
        guard let request = requestManager.getPromos() else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func postRegisterUser(user: UserRegister, completion: @escaping (Result<RegisterResult, Error>) -> Void) {
        guard let request = requestManager.postUserRegister(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postConfirmUser(user: UserConfirm, completion: @escaping (Result<UserConfirmResult, Error>) -> Void) {
        guard let request = requestManager.postUserConfirm(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postAgainConfirmCode(user: AgainConfirmCode, completion: @escaping (Result<AgainConfirmCodeResult, Error>) -> Void) {
        guard let request = requestManager.postAgainConfirmCode(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func login(user: Login, completion: @escaping (Result<LoginResultData, AppError>) -> Void) {
        guard let request = requestManager.postLogin(body: user) else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func postImages(_ images: [Data], progress: @escaping ((Double) -> Void), completion: @escaping (Result<APIDataMock, AppError>) -> Void) {
        let stringUrl = requestManager.postDocuments()
        networkAlamofire.postImages(images, stringUrl: stringUrl, progress: progress, completion: completion)
    }
    
    func logout(completion: @escaping (Result<Logout, Error>) -> Void) {
        guard let request = requestManager.postLogout() else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postChangePwassword(password: ChangePassword, completion: @escaping (Result<ChangePasswordResult, AppError>) -> Void) {
        guard let request = requestManager.postChangePassword(body: password) else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func postDropPassword(email: DropPassword, completion: @escaping (Result<DropPasswordResult, AppError>) -> Void) {
        guard let request = requestManager.postDropPasswoed(body: email) else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func getUserProfile(completion: @escaping (Result<UserProfile, AppError>) -> Void) {
        guard let request = requestManager.getUserProfile() else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func deleteUser(completion: @escaping (Result<UserDelete, AppError>) -> Void) {
        guard let request = requestManager.userDelete() else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
    
    func fetchCities(completion: @escaping (Result<[City], AppError>) -> Void) {
        guard let request = requestManager.getCities() else { return }
        networkAlamofire.fetch(request: request, completion: completion)
    }
}
