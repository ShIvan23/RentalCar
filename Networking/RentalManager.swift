//
//  RentalManager.swift
//  RentalCar
//
//  Created by Ivan on 11.03.2022.
//

import Foundation

final class RentalManager {
    
    private let networkManager = NetworkManager()
    private let requestManager = RequestManager()
    
    func fetchCars(completion: @escaping (Result<CarsModel, Error>) -> Void) {
        guard let request = requestManager.getAllAuto() else { return }
        networkManager.fetch(request: request, completion: completion)
    }
}
