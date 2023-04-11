//
//  AppStorage.swift
//  RentalCar
//
//  Created by Shishkin Ivan Sergeevich on 31.03.2023.
//

import Foundation

// Хранилище всех моделей. Подгрузка идет при старте приложения
final class AppStorage {
    
    static let shared = AppStorage()
    
    private init() {
        makeConditions()
    }
    
    private(set) var cities = [City]()
    private(set) var carClasses = [CarClass2]()
    private(set) var carBrands = [String]()
    private(set) var legal = [CommercialModel]()
    private(set) var promo = [PromoData]()
    private(set) var conditions = [ConditionsModel]()
    
    func updateCities(_ cities: [City]) {
        self.cities = cities
    }
    
    func updateClasses(_ carClasses: [CarClass2]) {
        self.carClasses = carClasses
        makeCarBrands()
        makeLegal()
    }
    
    func updatePromo(_ promo: [PromoData]) {
        self.promo = promo
    }
    
    private func makeCarBrands() {
        var setCars = Set<String>()
        carClasses.forEach { carClass in
            carClass.auto?.forEach { car in
                setCars.insert(car.brand ?? "")
            }
        }
        carBrands = Array(setCars).sorted()
    }
    
    private func makeLegal() {
        legal = CommercialModel.makeCommercialModel(cars: carClasses)
    }
    
    private func makeConditions() {
        conditions = ConditionsModel.makeConditionsModel()
    }
}
