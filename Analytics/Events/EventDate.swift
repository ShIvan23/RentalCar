//
//  EventDate.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation

enum EventDate: AnalyticProtocol {
    
    var name: String { return "Дата эвента" }
    var param: String { return Date().string(dateFormat: .imagePickerDateFormat) }
    
    case date
}
