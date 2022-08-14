//
//  Logger.swift
//  RentalCar
//
//  Created by Ivan on 11.08.2022.
//

import Foundation
import YandexMobileMetrica

final class Logger {
    
    static func logEvent(_ eventName: EventName, parameters: [AnalyticProtocol]) {
        var dict: [AnyHashable : String] = [:]
        parameters.forEach { dict[$0.name] = $0.param }
        YMMYandexMetrica.reportEvent(eventName.rawValue, parameters: dict)
    }
}
