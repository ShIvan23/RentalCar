//
//  CarNameEvent.swift
//  RentalCar
//
//  Created by Ivan on 14.08.2022.
//

import Foundation
 
enum CarNameEvent: AnalyticProtocol {
    
    var name: String { return "Выбрана машина" }
    var param: String { return value }
    
    case selectedCar(String)
    
    var value: String {
        switch self {
        case .selectedCar(let car):
            return car
        }
    }
}
