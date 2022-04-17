//
//  RentalManager.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import Foundation

protocol RentalManager {
    func fetchCars(completion: @escaping (Result<CarsModel, Error>) -> Void)
    func postOrder(order: Order, completion: @escaping (Result<OrderResult, Error>) -> Void)
    func fetchPromos(completion: @escaping (Result<Promos, Error>) -> Void)
    func postRegisterUser(user: UserRegister, completion: @escaping (Result<RegisterResult, Error>) -> Void)
    func postConfirmUser(user: UserConfirm, completion: @escaping (Result<UserConfirmResult, Error>) -> Void)
    func postAgainConfirmCode(user: AgainConfirmCode, completion: @escaping (Result<AgainConfirmCodeResult, Error>) -> Void)
    func login(user: Login, completion: @escaping (Result<LoginResult, Error>) -> Void)
}

final class RentalManagerImp: RentalManager {
    
    private let networkManager: NetworkManager = NetworkManagerImp()
    private let requestManager: RequestManager = RequestManagerImp()
    
    func fetchCars(completion: @escaping (Result<CarsModel, Error>) -> Void) {
        guard let request = requestManager.getAllAuto() else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func postOrder(order: Order, completion: @escaping (Result<OrderResult, Error>) -> Void) {
        guard let request = requestManager.postOrder(body: order) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
    
    func fetchPromos(completion: @escaping (Result<Promos, Error>) -> Void) {
        guard let request = requestManager.getPromos() else { return }
        networkManager.fetch(request: request, completion: completion)
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
    
    func login(user: Login, completion: @escaping (Result<LoginResult, Error>) -> Void) {
        guard let request = requestManager.postLogin(body: user) else { return }
        networkManager.fetch(request: request, completion: completion)
    }
}
