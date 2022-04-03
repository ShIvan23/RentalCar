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
}
