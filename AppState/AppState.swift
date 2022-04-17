//
//  AppState.swift
//  RentalCar
//
//  Created by Ivan on 16.04.2022.
//

import Foundation

protocol AppStateProtocol {
    var wasSentRegisterCode: Bool { get }
    var wasFinishedRegistration: Bool { get }
    var userEmail: String { get set }
    func saveToUserDefaults(key: AppStateKeys, value: Bool)
}

enum AppStateKeys: String {
    case wasSentRegisterCodeKey
    case wasFinishedRegistration
}

final class AppState: AppStateProtocol {
    
    static var shared: AppStateProtocol = AppState()
    
    private init() {
       // goToDefault()
        loadFromUserDefaults()
    }
    
    /// States
    var wasSentRegisterCode: Bool = false
    var wasFinishedRegistration: Bool = false
    
    /// User email
    var userEmail: String = ""
    
    func saveToUserDefaults(key: AppStateKeys, value: Bool) {
        let userDefaults = UserDefaults.standard
        
        switch key {
        case .wasSentRegisterCodeKey:
            wasSentRegisterCode = value
            userDefaults.setValue(value, forKey: AppStateKeys.wasSentRegisterCodeKey.rawValue)
            
        case .wasFinishedRegistration:
            wasFinishedRegistration = value
            userDefaults.set(value, forKey: AppStateKeys.wasFinishedRegistration.rawValue)
        }
    }
    
    private func loadFromUserDefaults() {
        let userDefaults = UserDefaults.standard
        
        wasSentRegisterCode = userDefaults.bool(forKey: AppStateKeys.wasSentRegisterCodeKey.rawValue)
    }
    
    // For tests
    
    private func goToDefault() {
        saveToUserDefaults(key: AppStateKeys.wasSentRegisterCodeKey, value: false)
    }
}
